---
title: "[.NET Core] 在 Ubuntu 20.04 上部署 .NET Core 3.1 (使用 Nginx 反向代理)"
date: 2021-08-11T16:48:00+08:00
lastmod: 2021-08-11T16:48:00+08:00
draft: false
tags: [ "Nginx", "Linux", "Ubuntu", ".NET Core 3.1"]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: true
---
# 設置 Ubuntu
## 安裝 .NET Core Runtime
```bash
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb 
sudo dpkg -i packages-microsoft-prod.deb 
sudo apt update 
sudo apt install apt-transport-https 
sudo apt install dotnet-runtime-3.1
```
## 安裝 Nginx
新增套件來源，新增檔案 /etc/apt/sources.list.d/nginx.list
```bash
#/etc/apt/sources.list.d/nginx.list.
deb https://nginx.org/packages/ubuntu/ focal nginx
deb-src https://nginx.org/packages/ubuntu/ focal nginx
```
安裝
```bash
sudo apt update
sudo apt install nginx -y
```
啟動、設定開機啟動
```bash
# 啟動 nginx
sudo systemctl start nginx
# 設置 nginx 開機啟動
sudo systemctl enable nginx
# 確認 nginx 運行狀態
sudo systemctl status nginx
```
設置 Nginx 反向代理本機的 5000 連接埠(之後 Kestrel 的 http 服務端口)
```yaml
server {
    listen        80;
    server_name   example.com *.example.com;
    location / {
        proxy_pass         http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
    }
}
```
重新載入 nginx 設定
```bash
sudo systemctl reload nginx
```
## 設定 kestrel service
將建置好的發佈檔案上傳，假設上傳到`/var/www/helloapp` dll檔是`helloapp.dll`。

將使用者改成`www-data`
```bash
sudo chmod -R www-data:www-data /var/www/helloapp
```
新增一個服務檔案`/etc/systemd/system/kestrel-helloapp.service`，設置如下：
```toml
# /etc/systemd/system/kestrel-helloapp.service
[Unit]
Description=Example .NET Web API App running on Ubuntu

[Service]
WorkingDirectory=/var/www/helloapp
# 呼叫安裝的 .net core 環境來執行 helloapp
ExecStart=/usr/bin/dotnet /var/www/helloapp/helloapp.dll
Restart=always
# 如果 .net core 服務崩潰的話 10秒後嘗試重新啟動
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=dotnet-example
User=www-data
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
```
把服務設定為開機啟動
```bash
sudo systemctl enable kestrel-helloapp.service
```
> 查看 kestrel service 的執行日誌：`journalctl -fu kestrel-helloapp.service`
# 設置 .NET Core 程式碼
```c#
// 只在 Linux 啟用 Reverse Proxy 模式 
if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
{
    app.UseForwardedHeaders(new ForwardedHeadersOptions
    {
        ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
    });
}
```
這裡是預設 nginx、運行 .net core 的 Kestrel 都在同一台機器上，
如果使用 127.0.0.0/8 、 [::1]以外的伺服器作為 proxy，也就是說 nginx 在其他機器上，
則需要在 ConfigureServices 裡面像這樣額外設定信任的伺服器：
```c#
services.Configure<ForwardedHeadersOptions>(options =>
{
    options.KnownProxies.Add(IPAddress.Parse("10.0.0.100"));
});
```
> Web api template 預設會將 http 導向至 https 協議 (也就是說會把 5000 重新導向至 5001)
因此 Nginx 如果是反向代理 5000 port，
則需要把 web api 當中的 `middleware app.UseHttpsRedirection();` 移除
(或是在 nginx 直接設置反向代理 .net core 的 https port)
安裝 Nginx

> 如果是用 Web Api 專案搭配前端開發 SPA，
> 可安裝擴充套件
> [Microsoft.AspNetCore.SpaServices.Extensions](https://www.nuget.org/packages/Microsoft.AspNetCore.SpaServices.Extensions/3.1.17?_src=template)，
> 並且在 middleware 最後設置路由 `app.UseSpa(spa => { });`。
> 也可以不安裝擴充套件改用以下的程式碼手動進行設定：
> ```c#
>// 搭配 vue router history mode 重寫路徑請求
>app.Use(async (ctx, next) =>
>{
>    await next();
>    bool is404 = ctx.Response.StatusCode == 404;
>    bool hasExt = Path.HasExtension(ctx.Request.Path.Value);
>    if (is404 && !hasExt)
>    {
>        ctx.Request.Path = "/index.html";
>        ctx.Response.StatusCode = 200;
>        await next();
>    }
>});
> ```
# 強化安全性
## 設定 https
拿到憑證之後可以進行設定，
Nginx 裡面憑證設定方式可以參考 [ssl 設定產生器](https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=intermediate&openssl=1.1.1d&guideline=5.6)。

如果要使用到自簽憑證可以用下面的方式產生：
```bash
sudo mkdir /etc/ssl/private
sudo chmod 700 /etc/ssl/private
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
```
接著在 Nginx.conf 檔案裡面設定：
```yaml
    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
```

## 設置防火牆
安裝啟用 Linux 安全性模組 (LSM) 裡面的 ufw 防火牆，
只允許 ssh、http、https(也可以選擇不要允許 http)：
```bash
sudo apt-get install ufw
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```
## 隱藏 Nginx 資訊 
編輯 `src/http/ngx_http_header_filter_module.c` 變更 Nginx 回應名稱：
```c
static char ngx_http_server_string[] = "Server: Web Server" CRLF;
static char ngx_http_server_full_string[] = "Server: Web Server" CRLF;
```
# Reference
- [MSDN - Host ASP.NET Core on Linux with Nginx](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-3.1)