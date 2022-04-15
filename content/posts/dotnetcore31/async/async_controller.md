---
title: "[.NET Core] 不阻塞的非同步控制器(Non-Blocking Asynchronous Controllers)"
date: 2021-03-17T03:32:00+08:00
lastmod: 2021-03-17T03:32:00+08:00
draft: false
tags: ["Task", "TAP", "non-blocking", "Asynchronous" ]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: true
---
ASP .NET Core 當中的 Web 控制器屬於IO密集的應用程式，當中主要使用的 TAP 是一種簡易使用、語言層級的非同步設計模式。
透過 TAP 可設計出非同步(Asynchronous)/非阻塞(Non-Blocking)的 Web API，大幅提高 Web 應用程式的併發性(Concurrency)。

# 非同步方法
C# 當中基於 TAP 設計的的非同步方法 (TAP method) 有幾個特性：
- 產生可等待 awaitable 型別
  (Task, Task\<TResult>, ValueTask, 和 ValueTask\<TResult>)，
  其中以 Task、Task\<TResult>最常見。
- 非同步方法的參數順序通常跟同步版本的方法相同，但方法名稱以 Async 結尾。

# async、await
await 運算子用來等待非同步行為完成，
或等待非同步行為完成後解析回傳值，
await 運算子只能用在非同步方法中，
因此 await 運算子的外層方法必須套用 async 修飾，
否則會出現錯誤。

# 非同步 Action 設計原則：
## 總是加上 async 關鍵字
async 的方法裡面可以等待非同步方法。
action 前加上 async 的作用在於建立一個管理回傳任務的狀態機(state machine)，
當 async 方法擲出例外時會被狀態機捕獲並放到任務中回傳，
而這也是以 Task 作為回傳值的方法的預期行為。
如果沒有 async 關鍵字則擲出的例外會被直接傳遞到呼叫者(caller)，
因此除非確定該 aciton 不會擲出任何例外，否則一律加上 async。

## 在Action中使用非同步方法：
在**非同步方法**中長時間執行**同步方法**會阻塞造成**其他非同步方法**初始化執行而降低併發性。
且如果 API 回傳型別是 Task 但卻只使用同步函式，
那該API的行為就只是同步。
以 Dapper 存取資料庫為例子，用 QueryAsync 代替 Query，
可以避免在 Query 在等待回應的時候阻塞其他非同步方法的執行。

# 範例
透過建立一個非同步的 Controller 由前端呼叫，可以獲得非阻塞的結果：
```c#
[Route("api/[controller]")]
[ApiController]
public class TaskController : ControllerBase
{
    [HttpGet("Delay")]
    public async Task<IActionResult> Delay()
    {
        var controllerName = "Delay";
        var startTime = DateTime.Now.ToString("HH:MM:ss.fff");
        await Task.Delay(5000);
        var endTime = DateTime.Now.ToString("HH:MM:ss.fff");
        return Ok(new { controllerName, startTime, endTime });
    }
}
```
在前端以 javscript 程式碼測試可以觀察到非阻塞 api：
```js
function callApi(url){
	fetch(url)
	.then(function(res) {
		return res.json();
	})
	.then(function(json) {
		console.log(json);
	});
}
callApi('api/Task/Delay')
callApi('api/Task/Delay')
// {controllerName: "Delay", startTime: "02:03:46.720", endTime: "02:03:51.764"}
//{controllerName: "Delay", startTime: "02:03:46.720", endTime: "02:03:51.764"}
```

P.S. 測試當下無法在Edge瀏覽器中呼叫同一支 api 獲得非阻塞結果，
同時呼叫 api 第二次呼叫會被瀏覽器排在第一次呼叫之後執行，
看起來會像是該 api 在伺服器端發生了阻塞，
但是 Chrome 卻沒有這個情況，可能是瀏覽器政策不同，
無論如何後端回傳 Task 的 Controller 行為都是非阻塞的。

# Reference
- [MSDN - Asynchronous programming](https://docs.microsoft.com/en-us/dotnet/csharp/async)
- [MSDN - Task-based asynchronous pattern](https://docs.microsoft.com/en-us/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap)
- [stackoverflow - Task without async/await in controller action method](https://stackoverflow.com/questions/59823334/task-without-async-await-in-controller-action-method)