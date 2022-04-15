---
title: "[JS] Object 常用方法"
date: 2020-05-20T23:31:18+08:00
hero: 
menu:
  sidebar:
    name: "[JS] Object 常用方法"
    identifier: js-obj-func
    parent: Javascript
    weight: 1000
---

紀錄常用的 Object 方法，細節可以到MDN看

# Object.create
> Object.create(proto, [propertiesObject])

以傳入的參數作為prototype建立一個新物件，這個方法只能複製只帶有 primitive type 無法 deep copy，建立的物件所帶的函式、巢狀物件、Array等等…都和 prototype 共用。

## 以特定Object 作為 Prototype 建立新物件

```js
const objParent = {
  parentFeild: 'parent feild',
  parentFunc: function () {
    console.log('This is parent Func')
  },
  deepObj: {
    a: 1,
    b: 2,
  },
}

// 以 objParent 作為 prototype 建立 obj 物件
const obj = Object.create(objParent)

// objFeild 只存在 obj 上
obj.objFeild = 'obj feild'

// 可從建立的 obj 呼叫 prototype 的屬性, 方法
obj.parentFeild // "parent feild"
obj.parentFunc() // This is parent Func

// 從 prototype 繼承的屬性可覆寫
obj.parentFeild = 'overite str'
obj.parentFeild // "overite str"

// 父子元件的深層物件仍然指向同一個
obj.deepObj.a // 1
objParent.deepObj.a = 9
obj.deepObj.a // 9
```

# Object.fromEntries
從 Array 或 key-value map 產生 Object

> Object.fromEntries(iterable);

## 從 Array 或 Map 產生 Object
```js
// 從 Map 產生 Object
const map = new Map([ ['foo', 'bar'], ['baz', 42] ]);
const obj = Object.fromEntries(map);
console.log(obj); // { foo: "bar", baz: 42 }
// 從 Array 產生 Object
const arr = [ ['0', 'a'], ['1', 'b'], ['2', 'c'] ];
const obj = Object.fromEntries(arr);
console.log(obj); // { 0: "a", 1: "b", 2: "c" }
```

## 搭配 Array.prototype.map 對 Object 元素迭代處理
```js
const object1 = { a: 1, b: 2, c: 3 };
const object2 = Object.fromEntries(
  Object.entries(object1)
  .map(([ key, val ]) => [ key, val * 2 ])
);

console.log(object2);
// { a: 2, b: 4, c: 6 }
```
# Object.assign
> Object.assign(target, …sources)

將(多個)來源物件(…sources)的屬性合併到目標物件(target)上，並回傳合併後的目標物件(target)。如果來源物件或目標物件有相同屬性，位於較後面的參數的物件屬性會覆蓋前面的，非深層複製，對於物件中的陣列、子物件只能複製參照。

## 複製物件
```js
const obj = { a: 1 };
const copy = Object.assign({}, obj);
console.log(copy); // { a: 1 }
// 原物件改變不會影響到複製的物件
obj.a=2
copy.a // 1
```

## 合併物件
```js
const o1 = { a: 1 };
const o2 = { b: 2 };
const o3 = { c: 3 };

const obj = Object.assign(o1, o2, o3);
console.log(obj); // { a: 1, b: 2, c: 3 }
// 由於 o2, o3 合併到 o1，所以 o1 改變
console.log(o1);  // { a: 1, b: 2, c: 3 }
// 回傳的 obj ,被合併的 o1　實際上是同一個物件的參照
o1===obj // true
```
# Object.entries
> Object.entries(obj)

取得 [key, value]的 map array進行迭代。

## 取得物件的 Key-Value Map
``` js
const obj = { foo: 'bar', baz: 42 }; 
const map = new Map(Object.entries(obj));
console.log(map); // Map { foo: "bar", baz: 42 }
```

## 配合 Array 的解構賦值迭代物件
取得Map之後就不指向原物件，因此無法用這個方法改變原物件
```js
const obj = { foo: 'bar', baz: 42 };
// [key, value] 運用了　Array Destructuring
Object.entries(obj).forEach(([key, value]) => console.log(`${key}: ${value}`)); // "foo: bar", "baz: 42"
```

# Object.values
> Object.values(obj)

Object.keys 取得可列舉屬性的 Array，順序和 for…in 語句一樣，差別在於 for….in 會列舉出原型鏈中的屬性但 Object.keys 不會。

## 取得物件屬性陣列
```js
const object1 = {
  a: 'somestring',
  b: 42,
  c: false
};

console.log(Object.values(object1));
```

# Object.keys
> Object.keys(obj)

Object.keys 取得可列舉屬性的”名稱”的 Array

## 取得物件的 Key Array
```js
const object1 = {
  a: 'somestring',
  b: 42,
  c: false
};

console.log(Object.keys(object1));
// expected output: Array ["a", "b", "c"]
```

# Reference
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object