---
title: "[.NET Core] ASP .NET Core 3.1 驗證與授權(四)-授權設定"
date: 2020-12-31T14:08:00+08:00
lastmod: 2020-12-31T14:08:00+08:00
draft: true
tags: ["Authentication", "dotNetCore", "Authorization"]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: true
---

# 授權(Authorization)
- 授權(Authorization): 界定用戶可存取資源範圍的程序。
## Policy-based authorization
ASP .NET Core 的授權以政策 Policy 進行設定
## 自訂授權
## RBAC
Name 記載使用者識別名稱(User Identity)
userData 記載以 `|` 分隔的使用者角色 Role

# 驗證與授權
## Challenge、Forbid
## 中間件順序
先驗證、再授權
The Order of UseAuthentication、UseAuthorization



# Reference
- [MSDN - Principal and Identity Objects](https://docs.microsoft.com/en-us/dotnet/standard/security/principal-and-identity-objects)
- [MSDN - IAuthenticationService Interface](https://docs.microsoft.com/zh-tw/dotnet/api/microsoft.aspnetcore.authentication.iauthenticationservice?view=aspnetcore-3.1)
- [MSDN - AuthenticationService Class](https://docs.microsoft.com/zh-tw/dotnet/api/microsoft.aspnetcore.authentication.authenticationservice?view=aspnetcore-3.1)
- [MSDN - Overview of ASP.NET Core Security](https://docs.microsoft.com/zh-tw/aspnet/core/security/?view=aspnetcore-3.1)
- [MSDN - Overview of ASP.NET Core authentication](https://docs.microsoft.com/en-us/aspnet/core/security/authentication/?view=aspnetcore-3.1)
- [MSDN - Policy-based authorization in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/security/authorization/policies?view=aspnetcore-3.1)
- [MSDN - Microsoft.AspNetCore.Authentication.Cookies Namespace](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.cookies?view=aspnetcore-5.0)
- [MSDN - Microsoft.AspNetCore.Authentication.JwtBearer Namespace](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.jwtbearer?view=aspnetcore-5.0)
- [[ASP.NET Core] 加上簡單的Cookie登入驗證](https://dotblogs.com.tw/Null/2020/04/09/162252)

https://blog.johnwu.cc/article/ironman-day11-asp-net-core-cookies-session.html
