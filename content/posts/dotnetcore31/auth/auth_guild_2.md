---
title: "[.NET Core] ASP .NET Core 3.1 驗證與授權(二)-驗證設定"
date: 2020-11-23T15:46:00+08:00
lastmod: 2021-03-12T23:08:00+08:00
draft: false
tags: ["Authentication", "dotNetCore"]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: true
---
# 驗證方案(Authentication Scheme)

驗證方案包含兩個部分：
- 驗證處理函式(Authentication handler)，可能是
[IAuthenticationHandler](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.iauthenticationhandler?view=aspnetcore-3.1) 或 
[AuthenticationHandler<TOptions>](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.authenticationhandler-1?view=aspnetcore-3.1)
的實作，相當於驗證方案的**行為**，責任範圍涵蓋:
    - 驗證使用者，
    - 驗證成功時，建構呈現使用者識別(user identity)的 [AuthenticationTicket](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.authenticationticket?view=aspnetcore-3.1)。
    - 驗證失敗時，回傳 'no result' 或 'failure'
    - 負責從請求上下文(request context)中建構使用者識別 (user identity)。
    - 定義了 challenge/forbid action。
- 驗證處理函式的設定選項(Opitons of Authentication handler)。

驗證方案當中的 authencate action 負責從請求上下文(request context)中建構使用者識別 (user identity)，
常見的例子為：
- **cookie authentication scheme** 從 cookie 資訊建構 user identity.
- **JWT bearer scheme** 反序列化(deserialize)、驗證(validate) token，並從 token 所攜帶資訊建構 user identity

## 使用驗證方案
在 Startup.ConfigureServices 以 AddAuthentication 註冊驗證服務時會回傳一個 AuthenticationBuilder，
AuthenticationBuilder 設定驗證方案的方式有：
- 呼叫 __scheme-specific 擴充方法__，例如 AddJwtBearer、AddCookie，這些擴充方法會自動呼叫 AuthenticationBuilder.AddScheme 設定需要的驗證方式。
- 以 AuthenticationBuilder __內建方法 AddScheme__ 手動設定，一般來說較少使用。  

P.S.另外可使用 [polycy schemes](https://docs.microsoft.com/zh-tw/aspnet/core/security/authentication/policyschemes?view=aspnetcore-3.1) 把多個 scheme 整合到一個使用。

# 範例
以上 Scheme 的文字較抽象較難理解記憶，以下直接實作註冊 IAuthenticationService，
並直接呼叫 scheme-specific 擴充方法添加 Cookie、JWT Scheme：  

## 安裝 scheme 套件
安裝 scheme 套件取得 Cookie、JWT 的 scheme-specific 擴充方法：
```shell
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer --version 3.1.10
dotnet add package Microsoft.AspNetCore.Authentication.Cookies --version 2.2.0
```
在 Startup.cs 添加對 scheme 的引用
```c#
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authentication.Cookies;
```
## 註冊驗證服務
在 Startup.ConfigureServices 加入下面程式碼，AddAuthentication 會將 IAuthenticationService 驗證服務注入服務容器，
[AddJwtBearer](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.jwtbearerextensions.addjwtbearer?view=aspnetcore-5.0&viewFallbackFrom=aspnetcore-3.1)、
[AddCookie](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.cookieextensions.addcookie?view=aspnetcore-3.1)
 分別為驗證服務添加兩種可用的 JWT、Cookie 驗證方案，
並透過 Action (就是那個 options => ... )設定相關的處理函式與設定選項。  
若 Authorization Attribute 或 Policy 沒有指定 Scheme，預設會使用 AddAuthentication() 方法中傳入作為參數的 Scheme，同理若是服務容器中提供多種驗證服務，可在 Controller 的授權屬性指定套用的 Scheme 或 Policy：
```c#
// 若沒有指定 Scheme 作 Authorization ，預設使用 JwtBearerDefaults.AuthenticationScheme
services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    // 讓 AP 可使用 JwtBearerDefaults.AuthenticationScheme 作為驗證方法
    .AddJwtBearer(
        JwtBearerDefaults.AuthenticationScheme,
        options => {
            // [注意]先解除 MapInboundClaims，否則會因為套件中某些為向前相容而保留的 legacy code 使得 RoleClaimType 無法生效
            // https://github.com/AzureAD/azure-activedirectory-identitymodel-extensions-for-dotnet/issues/1214
            if (options.SecurityTokenValidators.FirstOrDefault() is JwtSecurityTokenHandler jwtSecurityTokenHandler)
                jwtSecurityTokenHandler.MapInboundClaims = false;
            // 設置 Token 在授權後是否要儲存於 AuthenticationProperties 
            options.SaveToken = true;
            // 設置各Token驗證參數
            options.TokenValidationParameters = new TokenValidationParameters
            {
                NameClaimType = "userId", // 設置 Http 請求的 User.Identity.Name、Hub 中 UserIdentifier 取值的  Claim 是 userId
                RoleClaimType = "roles", // 設置使用者的腳色從 type="roles" 的 claims 對應
                ValidateLifetime = true, // 驗證 Token 有效期間
                ValidateIssuerSigningKey = true, // 驗證 token 中的 key
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(config.GetValue<string>("JWT:SignKey"))),  // 從 appsettings.json 拿 SignKey
                ValidateIssuer = true, // 驗證簽發者
                ValidateAudience = false  // 不驗證 Audience (Token接收方)
            };
            // 預設是從 Header 拿 token，如果客戶端用其他方式攜帶 token 例如網址列
            // 就要設置 options.Event 拿取 token 後設置到 MessageReceiveContext 才能抓得到
        })
    // 讓 AP 可使用 CookieAuthenticationDefaults.AuthenticationScheme 作為驗證方法
    .AddCookie(
        CookieAuthenticationDefaults.AuthenticationScheme,
        options => {
            // 自訂 Cookie 名稱
            options.Cookie.Name= ".CookieName"; 
            // 設置未驗證進入點，預設是 /Account/Login
            options.Cookie.LoginPath = new PathString("/..."); 
        });
```

# Reference
- [MSDN - Overview of ASP.NET Core authentication](https://docs.microsoft.com/en-us/aspnet/core/security/authentication/?view=aspnetcore-3.1)
- [MSDN - Microsoft.AspNetCore.Authentication.Cookies Namespace](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.cookies?view=aspnetcore-3.1)
- [MSDN - CookieAuthenticationOptions Class](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.cookies.cookieauthenticationoptions?view=aspnetcore-3.1)
- [MSDN - Microsoft.AspNetCore.Authentication.JwtBearer Namespace](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.jwtbearer?view=aspnetcore-5.0)
- [MSDN - polycy schemes](https://docs.microsoft.com/zh-tw/aspnet/core/security/authentication/policyschemes?view=aspnetcore-3.1)
- [Authentication handler in ASP.Net Core (JWT and Custom)](https://dotnetcorecentral.com/blog/authentication-handler-in-asp-net-core/)
- [The Will Will Web - 如何在 ASP.NET Core 3 使用 Token-based 身分驗證與授權 (JWT)](https://blog.miniasp.com/post/2019/12/16/How-to-use-JWT-token-based-auth-in-aspnet-core-31)
- [The Will Will Web - 如何實作沒有 ASP.NET Core Identity 的 Cookie-based 身分驗證機制](https://blog.miniasp.com/post/2019/12/25/asp-net-core-3-cookie-based-authentication)
