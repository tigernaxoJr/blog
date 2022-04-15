---
title: "[.NET Core] 不阻塞的非同步控制器(Non-Blocking Asynchronous Controllers)"
date: 2021-03-13T00:07:00+08:00
lastmod: 2021-03-13T00:07:00+08:00
draft: true
tags: ["Task", "TAP", "non-blocking", "Asynchronous" ]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: true
---
無論是在 I/O-bound (IO密集)或 CPU-bound (CPU密集)類型的程式，非同步設計皆有發揮的空間。
而 C# 達成非同步程式設計的方法可以是
 TAP (Task-based Asynchronous Pattern)、
 APM (Asynchronous Programming Model) 或
 (EAP) pattern and the Event-based Asynchronous Pattern。
而 ASP .NET Core 當中的控制器屬於IO密集的應用程式，當中大量使用的 TAP 是一種簡易使用、語言層級的非同步設計模式

# TAP (Task-based Asynchronous Pattern)

any long-running work in the synchronous portion of an asynchronous method could delay the initiation of other asynchronous operations, thereby decreasing the benefits of concurrency.

controller 前有沒有加上 async 的不同
The async keyword creates a state machine, which is responsible for managing the returned Task. If the code in an async method throws an exception, then the async state machine captures that exception and places it on the returned Task. This is the expected semantics for a method that returns Task.
 that exception would be raised directly to the caller rather than being placed on the returned Task. These semantics are not expected.
 As a general rule, I recommend keeping the async and await keywords unless the method is trivial and will not throw an exception.
# Reference
- [MSDN - Asynchronous programming](https://docs.microsoft.com/en-us/dotnet/csharp/async)
- [MSDN - Task-based asynchronous pattern](https://docs.microsoft.com/en-us/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap)
- [stackoverflow - Task without async/await in controller action method](https://stackoverflow.com/questions/59823334/task-without-async-await-in-controller-action-method)
- [MSDN - Async/Await - Best Practices in Asynchronous Programming](https://docs.microsoft.com/en-us/archive/msdn-magazine/2013/march/async-await-best-practices-in-asynchronous-programming)