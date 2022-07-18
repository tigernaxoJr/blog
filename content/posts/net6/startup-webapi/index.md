---
title: "[Web] .NET 6 Web API 專案"
date: 2022-07-18T11:35:00+08:00
draft: true
hero: 
menu:
  sidebar:
    name: "[Web] .NET 6 Web API 專案"
    identifier: netcore6-startup-webapi
    parent: netcore6
    weight: 1000
---
## 添加 Swagger
```bash
dotnet add web-logger.csproj package Swashbuckle.AspNetCore -v 6.2.3
```
Program.cs
```c#
builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
```
`https://localhost:<port>/swagger/index.html`
添加一行 uniFormat 設置，讓專案除錯啟動的時候打開 swagger
讓Swagger 認得 IActionResult 的 api 接收/回傳型別
https://stackoverflow.com/questions/53105513/swagger-not-generating-model-for-object-wrapped-by-iactionresult
```json
"serverReadyAction": {
    "action": "openExternally",
    "pattern": "^\\s*Now listening on:\\s+(https?://\\S+)",
    "uriFormat": "%s/swagger"
}
```
ASP.NET Core doesn't include a logging provider for writing logs to files. To write logs to files from an ASP.NET Core app, consider using a third-party logging provider.
https://docs.microsoft.com/en-us/aspnet/core/fundamentals/logging/?view=aspnetcore-6.0
.NET Standard 2.0 之後內建沒有 ConfigurationManager ，需要額外安裝
`dotnet add package System.Configuration.ConfigurationManager --version 6.0.0`
https://stackoverflow.com/questions/46360716/cant-use-system-configuration-configuration-manager-in-a-net-standard2-0-libra
## Reference
https://docs.microsoft.com/en-us/aspnet/core/tutorials/getting-started-with-swashbuckle?view=aspnetcore-6.0&tabs=visual-studio-code