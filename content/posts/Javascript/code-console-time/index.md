---
title: "[Code] 測量程式執行時間"
date: 2020-11-13T06:26:00+08:00
hero: 
draft: true
menu:
  sidebar:
    name: "[Code] 程式執行時間"
    identifier: jscode-console-time
    parent: Javascript
    weight: 2000
---
```js
console.time('someFunction')

someFunction() 

console.timeEnd('someFunction')
```
# Reference 
- [MDN - Console.time()](https://developer.mozilla.org/en-US/docs/Web/API/Console/time)