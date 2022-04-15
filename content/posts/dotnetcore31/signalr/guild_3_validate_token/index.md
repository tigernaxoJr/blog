---
title: "[SignalR] Websocket 即時聊天程式(三) - 後端 Token 認證"
date: 2020-11-07T15:09:45+08:00
lastmod: 2020-11-20T22:44:00+08:00
draft: false
tags: ["SignalR", "dotNetCore", "Authentication", "Autherization", "Bearor Token"]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: true
#contentCopyright: '<a rel="license noopener" href="https://en.wikipedia.org/wiki/Wikipedia:Text_of_Creative_Commons_Attribution-ShareAlike_3.0_Unported_License" target="_blank">Creative Commons Attribution-ShareAlike License</a>'

---

# 安裝套件
要進行 Token 的認證，需要先安裝 Microsoft.AspNetCore.Authentication.JwtBearer 套件：
```shell
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
```
# 註冊認證服務
新增一個檔案 DependencyInjection.cs，在當中製作 IServiceCollection 的擴充方法來自定義 JWT token 認證服務，
在裡面設置 Token 的認證規則、使用者識別碼對應、使用者群組對應，
而 SignalR 抓取使用者識別碼 (UserIdentifier) 的介面方法是 IUserIdProvider.GetUserId，
因此我們需要另外新增一個實作 IUserProvider 的類別注入服務容器給 SignalR 使用
，該檔案程式碼如下： 
```cs
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using System.Diagnostics.CodeAnalysis;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Threading.Tasks;

namespace SignalR.Extensions.DependencyInjection
{
    public static class MyAddConfig
    {
        public static IServiceCollection AddMyJWTAuth(
            [NotNull] this IServiceCollection services,
            IConfiguration config
            )
        {

            services.AddAuthentication(options =>
            {
                // Identity 預設是使用 Cookie authentication，必須手動設置為 JWT Bearer Auth:
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(options =>
            {
                // [注意]先解除 MapInboundClaims ，否則會因為套件中某些為向前相容而保留的 legacy code 使得 RoleClaimType 無法生效
                // https://github.com/AzureAD/azure-activedirectory-identitymodel-extensions-for-dotnet/issues/1214
                if (options.SecurityTokenValidators.FirstOrDefault() is JwtSecurityTokenHandler jwtSecurityTokenHandler)
                    jwtSecurityTokenHandler.MapInboundClaims = false;
                // 設置 Token 在授權後是否要儲存於 AuthenticationProperties 
                options.SaveToken = true;
                // 設置各認證參數
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    NameClaimType = "userId", // 設置 Http 請求的 User.Identity.Name、Hub 中 UserIdentifier 取值的  Claim 是 userId
                    RoleClaimType = "roles", // 設置使用者的腳色從 type="roles" 的 claims 對應
                    ValidateLifetime = true, // 認證 Token 有效期間
                    ValidateIssuerSigningKey = true, //驗證 token 中的 key
                    IssuerSigningKey = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(config.GetValue<string>("JWT:SignKey"))),  // SignKey
                    ValidateIssuer = false, // 不驗證簽發者
                    ValidateAudience = false  // 不驗證 Audience (Token接收方)
                };

                options.Events = new JwtBearerEvents
                {
                    // 設定當 OnMessageReceived 事件被觸發時，獲取認證用的 access_token 
                    OnMessageReceived = context =>
                    {
                        // 不同於標準夾帶於 header 的 http token，signalr 會透過網址參數發送 access token 
                        // ASP .NET Core 預設會將請求的 URL 皆做成 Log 紀錄，如果不想要網址列的 Token 被 Log 記錄下來必須參考
                        //  https://docs.microsoft.com/aspnet/core/signalr/security#access-token-logging
                        string accessToken = context.Request.Query["access_token"];

                        // 檢查請求路徑是否為 chathub
                        var path = context.HttpContext.Request.Path;
                        if (!string.IsNullOrEmpty(accessToken) &&
                            (path.StartsWithSegments("/chathub")))
                        {
                            // 把 token 丟進 MessageReceiveContext 當中
                            context.Token = accessToken;
                        }
                        return Task.CompletedTask;
                    }
                };
            });

            services.AddSingleton<IUserIdProvider, NameUserIdProvider>();
            // 如果是使用 email claim 作為 user identifier 用下面這行並實作 EmailBasedUserIdProvider
            // services.AddSingleton<IUserIdProvider, EmailBasedUserIdProvider>();
            // NameUserIdProvider 和 EmailBasedUserIdProvider 無法同時使用!!
            return services;
        }
    }
    // 實作 SignalR 抓取使用者 Identity 的方法 IUserIdProvider.GetUserId
    // 提供服務容器注入給 SignalR 使用
    public class NameUserIdProvider : IUserIdProvider
    {
        public string GetUserId(HubConnectionContext connection)
        {
            // 認證設定時設置好 NameClaimType，這裡直接回傳 User.Identity.Name 即可
            return connection.User?.Identity?.Name;
        }
    }
}
```

然後在 Startup.cs 當中添加對該類別的引用：
```cs
using SignalR.Extensions.DependencyInjection;
```
在 Startup.ConfigureServices 中使用擴充方法將定義好的 JWT 認證注入 service
{{< highlight cs "hl_lines=6-7" >}}
public void ConfigureServices(IServiceCollection services)
{
    services.AddControllers();
    services.AddSignalR();

    // 設定 JWT Bearer Auth
    services.AddMyJWTAuth(Configuration);

    // 在 service container 當中註冊 JWT Option
    services.AddOptions<JWTOption>()
        .Bind(Configuration.GetSection(JWTOption.JWT));
}
{{< /highlight >}}

# 設置驗證中間件
修改 Configure ，在 ` app.UseAuthorization(); ` 之前加入 ` app.UseAuthorization(); `，順序必須要對，先驗證再授權：
{{< highlight cs "hl_lines=1" >}}
app.UseAuthentication();
app.UseAuthorization();
{{< /highlight >}}

# 添加 Hub 驗證屬性
現在不僅可成功添加授權屬性，經上面的設置將 roles claim 對應到使用者腳色，已經可以自動識別使用者群組，方便我們進行 RBAC
{{< highlight cs "hl_lines=1" >}}
[Authorize(Roles ="Admin")]
public async Task SendMessage(string user, string message)
{
    await Clients.All.SendAsync("ReceiveMessage", user, message);
}
{{< /highlight >}}

# 在 Hub 中解析 Claim
在 Hub 的方法內可以這樣取得 Token 相關資訊：
```cs
// 解析
var userId = Context.UserIdentifier;
// 解析 Claims
var claims = ((ClaimsIdentity)Context.User.Identity).Claims;
```

# 測試
...待補

# Reference
- [MSDN - Authentication and authorization in ASP.NET Core SignalR](https://docs.microsoft.com/en-us/aspnet/core/signalr/authn-and-authz?view=aspnetcore-3.1)
- [如何在 ASP.NET Core 3 使用 Token-based 身分驗證與授權 (JWT)](https://blog.miniasp.com/post/2019/12/16/How-to-use-JWT-token-based-auth-in-aspnet-core-31)
- [ASP.NET Core 认证与授权[4]:JwtBearer认证](https://www.cnblogs.com/RainingNight/p/jwtbearer-authentication-in-asp-net-core.html)
- [TokenValidationParameters Class](https://docs.microsoft.com/en-us/dotnet/api/microsoft.identitymodel.tokens.tokenvalidationparameters?view=azure-dotnet)