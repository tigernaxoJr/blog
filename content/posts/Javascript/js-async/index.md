---
title: "[JS] 非同步程式設計-Promise 與 Async/Await"
date: 2021-01-09T01:32:00+08:00
hero: 
menu:
  sidebar:
    name: "[JS] 非同步程式設計"
    identifier: js-async
    parent: Javascript
    weight: 1000
---
# Promise
## Promise 狀態
Promise function 執行後會立即回傳一個稱為 Promise 的物件，
Promise 本身帶有三種狀態：
- pending: 已初始化，但尚未成功或失敗。
- fulfilled: 操作成功完成。
- rejected: 操作失敗結束。

promise 一但被回傳就處於 pending 狀態，
promise 的建構式有兩個參數個接收一個 function，可以操作 Promise 的 fulfilled 和 rejected。

```js
// resolve(value): 放入解析的值
// reject(reson): 放入拒絕的理由
function test(value){
  let reason  = '找不到 value'
  return new Promise((resolve, reject)=>{
    value ? resolve(value) :reject(reason)
  })
}
```

## 將 Promise 繫結回呼函式
若要將某個程式語句安排在 Promise 被滿足之後執行。
可以利用 Promise.prototype 上的三個物件方法(Instance Method)方法繫結回呼函式(callback function)：
then catch finally
resolve 會被 then 捕獲，reject 會被最近的 catch 捕獲

## 管理多個同時執行的 Promise
假設需要同時控管多個需要等待的函數，
讓這些函數都回傳 promise，
判斷這些 promise function 其中一個/全部滿足某某狀態時就進行什麼動作，
Promise 上定義的靜態方法(Static Method)常被用來對一個以上的 Promise 進行一波騷操作：

Promise.All(iterable): iterable 中的 promise 皆被滿足時，Promise.All 本身回傳的 Promise 被滿足。
Promise.allSettled(iterable)
Promise.any(iterable)
Promise.race(iterable)
Promise.resolve(value)
Promise.reject(reason)
這兩個方法結合，比起 Promise 建構子能夠更優雅的回傳 Promise：
```js
function test(value){
  let reason  = '找不到 value'
  return value 
	? Promise.resolve(value)
	: Promise.reject(reason);
}
```

## 將 Promise 操作序列同步化(Async/Await)
async 是 promise 的語法糖，標記 async 的 function 本身會自動回傳 promise，
如過有回傳值就發生 resolved 函式；如果收到丟出的錯誤就放進 reject 往外傳遞。
async function 中可以使用 await 等待 promise 被 fulfilled 或 rejected，
使用 await 等待 promise 使函式行為同步化，也可以直接得到 resolve 當中的回傳值或 reject 中擲出的錯誤。
await 一個函式會得到 resolve 或 reject 的結果
```js
async function test(value){
  if(value) return value
  throw '找不到 value'
}
```

如此一來就可以取代以串接 .then() 安排程式執行順序，可以顯著減少 callback 的情況讓程式碼變乾淨。
javascript 沒有 top level await，所以無法在 async function 以外的地方使用 await。

## 搭配 try/catch 使用
# Reference
- [JavaScript 同步延遲 ( Promise + setTimeout )](https://www.oxxostudio.tw/articles/201706/javascript-promise-settimeout.html#_self)
- [簡單理解 JavaScript Async 和 Await](https://www.oxxostudio.tw/articles/201908/js-async-await.html)
- [從 Promise 開始的 JavaScript 異步生活](https://eyesofkids.gitbooks.io/javascript-start-es6-promise/content/)
- [JavaScript Promise 迷你書（ 中文版 )](http://liubin.org/promises-book/#chapter1-what-is-promise)
- [MDN - Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
- [MDN - Using Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises)