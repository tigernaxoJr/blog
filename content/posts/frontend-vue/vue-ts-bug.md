---
title: "[But] TypeScript 注意事項"
date: 2023-03-10T08:14:00+08:00
draft: false
hero: 
discription: TypeScript 注意事項
menu:
  sidebar:
    name: "[元件] TypeScript 注意事項"
    identifier: frontend-vue-ts-bug
    parent: frontend-vue
    weight: 1000
---
用這樣的寫法，會造成 IDE 異常
```js
:columns="columns as QTableProps['columns']"
```