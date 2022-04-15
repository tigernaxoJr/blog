---
title: "[.NET Core] ASP .NET Core 3.1 驗證與授權(X)-備註頁面"
date: 2090-11-23T15:48:00+08:00
lastmod: 2090-11-23T15:48:00+08:00
draft: true
tags: ["Authentication", "dotNetCore", "Authorization"]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: true
---
## Identity Objects
## Principal Objects
IPrincipal 物件帶有 IIdentity 物件的參考
可指定 Authentication Scheme 獲得 Identity
## IAuthenticationService
SignOutAsync 清除 Cookie 的 Claims
在 Cookie 寫入 Claims
## Token 登入

# 登入 API 實作
宣告 ClaimsPrincipal 後，可利用服務容器已注入的認證服務(實作 IAuthencationService 的類別)，進行登入、登出。
使用 SignInAsync 方法登入(寫入認證資訊)需要這些東西：
1. ClaimsPrincipal(必要)，我們需要 ClaimsPrincipal 攜帶 ClaimsIdentity 及 Claims。
2. AuthenticationScheme string (Optional)可指定 Scheme，若沒有給就是使用預設的 Scheme。
3. authProperties (Optional)，可指定自訂認證選項

# AuthenticationHttpContextExtensions
AuthenticationHttpContextExtensions 類別對 HttpContext 類別擴展出認證方法，
從服務容器中獲取 IAuthenticationService 實體類別，並調用同名方法。
# IAuthenticationService
SignOutAsync 清除 Cookie 的 Claims
可儲存 ClaimsPrincipal進行簽發(登入)認證，作為身分識別。
