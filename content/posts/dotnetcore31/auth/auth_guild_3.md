---
title: "[.NET Core] ASP .NET Core 3.1 驗證與授權(三)-Cookie 驗證實例"
date: 2020-12-30T23:24:00+08:00
lastmod: 2020-12-30T23:24:00+08:00
draft: false
tags: ["Authentication", "dotNetCore", "Authorization", "Cookie"]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: true
---
前兩篇介紹了驗證、授權在 .NET Core 當中的基本的概念，本節實作 Cookie 驗證的設定、簽發、登出...
# Configuration
在 Startup.ConfigureServices 方法中設置驗證方案，
並且可以在 AddCookie 當中設置 CookieAuthenticationOptions(見前一節)
```c#
// 設置 cookie 驗證作為應用程式預設的驗證方案
services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
// 將 cookie 服務添加到服務容器當中
    .AddCookie();
```
在 Startup.Configure 方法中，呼叫 UseAuthentication、UseAuthorization，
啟用驗證中間件並設置 HttpContext.User 屬性，
UseAuthentication 必須在 UseAuthorization 之前，且兩者都必須在 UseEndpoints 之前被呼叫：
```c#
app.UseAuthentication(); // 驗證
app.UseAuthorization(); // 授權

// 端點對應
app.UseEndpoints(endpoints =>
{
    endpoints.MapControllers();
    endpoints.MapRazorPages();
});
```
# Cookie Policy Middleware
在中間件當中設置的驗證政策會作用於全域(每個請求)，
舉例來說，最常用的就是限制應用程式所有 Cookie 的 SameSite 屬性，
所有 Controller 簽發的 Cookie.SamSite 屬性會被限縮為較嚴格(不比 MinimumSameSitePolicy 寬鬆)的設置：
```c#
app.UseCookiePolicy(new CookiePolicyOptions {
    // 所有 Cookie.SamSite 設置都會被提升為 Strict
    MinimumSameSitePolicy = SameSiteMode.Strict, 
    // Cookie.SamSite 設置為 None 的話會被提升為 Lax
    //MinimumSameSitePolicy = SameSiteMode.Lax,  
    // MinimumSameSitePolicy 設置為最寬鬆，因此不會影響 Cookie.SamSite
    //MinimumSameSitePolicy = SameSiteMode.None, 
});
```

# Create an authentication cookie
.NET Core 利用 ClaimsPrincipal 將序列化的使用者資訊儲存在 Cookie 當中
而 ClaimsPrincipal 可包含很多 ClaimsIdentity(但通常只有一個)；
ClaimsIdentity 可以且通常包含很多 Claims(聲明)，
而每個 Claims 是包含型別(ClaimType)、值(ClaimValue)。
因此為登入使用者建立 Cookie 驗證的步驟如下：
1. 建構 ClaimsPrincipal、ClaimsIdentity、Claims
2. 呼叫 SignInAsync 為 http 回應加上一個帶有使用者資訊的加密 cookie
```c#
var claims = new List<Claim> 
 {
    new Claim(ClaimTypes.Name, user.Email),
    new Claim("FullName", user.FullName),
    new Claim(ClaimTypes.Role, "Administrator"),
};

var claimsIdentity = new ClaimsIdentity(
    claims, CookieAuthenticationDefaults.AuthenticationScheme);

await HttpContext.SignInAsync(
    // 如果沒有在 SignInAsync 指定 AuthenticationScheme，會使用預設值
    CookieAuthenticationDefaults.AuthenticationScheme, 
    new ClaimsPrincipal(claimsIdentity), 
    new AuthenticationProperties {
      // 這裡可以自訂驗證選項...
      // 是否可自動更新 Cookie(時效?)
      //AllowRefresh = <bool>,
      // IsPersistent 設置 Persistent cookies，否則瀏覽器 session 關閉就失效
      //IsPersistent = true, 
      // Persistent cookie 可進一步設置失效時間：
      //ExpiresUtc = DateTimeOffset.UtcNow.AddMinutes(10),
      //IssuedUtc = <DateTimeOffset>,
      //RedirectUri = <string>
    }
);
```
# Sign out
登出非常簡單：
```c#
await HttpContext.SignOutAsync(
    CookieAuthenticationDefaults.AuthenticationScheme);
```
P.S. non-persistent cookies 在 **瀏覽器(browser)** 關閉時會自動清除，但關閉 **分頁(tab)** 時不會

# Reference
- [MSDN - Principal and Identity Objects](https://docs.microsoft.com/en-us/dotnet/standard/security/principal-and-identity-objects)
- [MSDN - IAuthenticationService Interface](https://docs.microsoft.com/zh-tw/dotnet/api/microsoft.aspnetcore.authentication.iauthenticationservice?view=aspnetcore-3.1)
- [MSDN - AuthenticationService Class](https://docs.microsoft.com/zh-tw/dotnet/api/microsoft.aspnetcore.authentication.authenticationservice?view=aspnetcore-3.1)
- [MSDN - Use cookie authentication without ASP.NET Core Identity](https://docs.microsoft.com/en-us/aspnet/core/security/authentication/cookie?view=aspnetcore-3.1)
- [[ASP.NET Core] 加上簡單的Cookie登入驗證](https://dotblogs.com.tw/Null/2020/04/09/162252)
- [Authentication handler in ASP.Net Core (JWT and Custom)](https://dotnetcorecentral.com/blog/authentication-handler-in-asp-net-core/)
