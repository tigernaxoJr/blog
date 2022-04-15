---
title: "[.NET Core] ASP .NET Core 3.1 的 Host"
date: 2020-11-16T06:19:00+08:00
lastmod: 2020-11-16T06:19:00+08:00
draft: true
tags: ["Host", "dotNetCore"]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: true
---
Host 是封裝整個應用程式資源的**物件**，在單一 Host 物件中包含所有應用程式資源的主要理由是管理應用程式的生命週期，包含啟動、關機。資源包含：
- Dependency injection (DI)
- Logging
- Configuration
- IHostedService 實作

Host 啟動時，對服務容器中每個註冊的 IHostedService 具體類別呼叫方法 StartAsync 啟動服務，
ASP 當中，服務容器中註冊了提供 web 服務的 IHostedService 實體類別，這個實體類別實作了 HTTP server。
# Generic Host
Web 專案在 .NET Core 2.2 前是直接起始一個 WebHost；
到了 .NET Core 3.0 之後包含 Web 專案一律使用 Generic Host，
接著才在 Generic Host 設置 Web 服務。
# Reference
- [MSDN - .NET Generic Host in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/host/generic-host?view=aspnetcore-3.1) 