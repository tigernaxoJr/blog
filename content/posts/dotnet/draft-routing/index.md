---
title: "[.NET Core] ASP .NET Core 3.1 的路由"
date: 2020-11-16T06:19:00+08:00
lastmod: 2020-11-16T06:19:00+08:00
draft: true
tags: ["Routing", "dotNetCore"]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: true
---
```cs
// 路由對應(route mapping)
app.UseRouting();

// 進入實際資源存取端點
app.UseEndpoints(endpoints =>
{
    // configure endpoints
});
```

# Reference
- [MSDN - Routing in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/routing?view=aspnetcore-3.1)