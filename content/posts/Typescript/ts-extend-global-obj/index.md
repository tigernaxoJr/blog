---
title: "[TS] Typescript 在標準內建物件加上屬性"
date: 2020-05-20T09:37:18+08:00
hero: 
menu:
  sidebar:
    name: "[TS] 擴充標準內建物件"
    identifier: ts-extend-global-obj
    parent: ts
    weight: 1000
---
### 宣告
這個動作是 Extends Array Interface
```ts
interface Array<T> {
  newfunc(o: T): Array<T>;
}

Array.prototype.newfunc = function (o) {
  // some code 
  return this;
}
```
### 使用
使用者要先拿到被 extend 的 interface
```ts
declare global {
  interface Array<T> {
    newfunc(o: T): Array<T>;
  }
}
```
## Reference
- [stackoverflow - extending array in typescript](https://stackoverflow.com/questions/12802383/extending-array-in-typescript)
- [bobbyhadz - typescript-array-extend](https://bobbyhadz.com/blog/typescript-array-extend)