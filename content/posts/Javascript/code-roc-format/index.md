---
title: "[Code] 格式化民國年"
date: 2023-06-06T06:00:00+08:00
hero: 
menu:
  sidebar:
    name: "[Code] 格式化民國年"
    identifier: jscode-roc-format
    parent: Javascript
    weight: 2000
---
這個方法用 proxy 擴充 dayjs，讓 dayjs 支援格式化民國年。
## JS 程式碼
 ```js
 // dayx.js
import day from 'dayjs'
const rocyyy = (dt)=>(dt.getFullYear() - 1911).toString().padStart(3, '0')
const prototype = Object.getPrototypeOf(day())
const handler = {
  get: function (target, prop, receiver) {
    // age, dte, tme
    if (prop === 'age') return day().diff(receiver, 'years', false)
    if (prop === 'dte') return receiver.format('YYYMMDD')
    if (prop === 'tme') return receiver.format('HHmmss')
    // format
    if (prop === 'format') return (format) =>{
        const formattingTokens = /Y{4,}|Y{3}|[^Y{3}]+/g
        const arr = format.match(formattingTokens)
        const ktformat = arr
          .map(x => x === 'YYY' ? rocyyy(target.$d) : x)
          .join('')
        return target.format(ktformat)
      }

    // Property is not function, else condition
    if (typeof target[prop] !== 'function') return target[prop]
    // Property is function, Wrap it
    return function (...args) {
      const result = target[prop].apply(target, args)
      if (Object.getPrototypeOf(result) === prototype) return p(result, handler)
      return result
    }
  },
  set(obj, prop, v, receiver) {
    if (prop === 'dte') {
      v = v.padStart(7, '0')
      const yyy = parseInt(v.substring(0, 3)) + 1911
      obj.$d.setFullYear(yyy)
      obj.$d.setMonth(parseInt(v.substring(3, 5)) - 1)
      obj.$d.setDate(parseInt(v.substring(5, 7)))
      return receiver
    }
    if (prop === 'tme') {
      v = v.padEnd(6, '0')
      obj.$d.setHours(parseInt(v.substring(0, 2)))
      obj.$d.setMinutes(parseInt(v.substring(2, 4)))
      obj.$d.setSeconds(parseInt(v.substring(4, 6)))
      return receiver
    }
    return Reflect.set(...arguments)
  },
}
const p = (...args) => new Proxy(day(...args), handler)

export default p
 ```
## 型別定義
```ts
// dayx.d.ts
import dayjs from "dayjs";

declare module 'dayjs' {
  interface Dayjs {
    age: number;
    dte: string;
    tme: string;
  }
}

export = dayjs;
export as namespace dayjs;
```
## 使用方式
可直接設定民國年，此外時間的加減乘除都可以參照 [dayjs 文件](https://day.js.org/docs/en/manipulate/manipulate)
```js
import dayx from "./dayx";
//#region 從資料庫的 dte, tme 欄位
let d = dayx();
d.dte = "1110315";
d.tme = "123338";
console.log(d.format("民國YYY年MM月DD日 HH:mm:ss"));
// 民國110年03月15日 12:33:38
//#endregion

//#region 從原生 Date
d = dayx("2022-03-15T12:33:38");
console.log(d.format("民國YYY年MM月DD日 HH:mm:ss"));
// 民國110年03月15日 12:33:38
//#endregion

//#region 使用當下時間不需要任何參數
d = dayx();
console.log(d.format("民國YYY年MM月DD日 HH:mm:ss"));
//#endregion
```

## Reference
- [Dayjs](https://day.js.org/docs/en/manipulate/manipulate)