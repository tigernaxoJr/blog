---
title: "[JS] Array 常用方法"
date: 2020-04-29T23:31:18+08:00
hero: 
menu:
  sidebar:
    name: "[JS] Array 常用方法"
    identifier: js-arr-func
    parent: Javascript
    weight: 1000
---

紀錄常用的 Array 方法，細節可以到MDN看
# 陣列操作
## 尾端彈出 Array.prototype.pop()、推入 Array.prototype.push()
> arr.pop()  
> arr.push(element1[, ...[, elementN]])
```js
const arr=[1, 2, 3, 4]
arr.pop()
console.log(arr)  // [1, 2, 3]
arr.push(5)
console.log(arr)  // [1, 2, 3, 5]
```
## 首端彈出 Array.prototype.shift()、推入 Array.prototype.unshift()
> arr.shift()  
> arr.unshift(element1[, ...[, elementN]])
```js
const arr=[1, 2, 3, 4]
arr.shift()
console.log(arr) // [2, 3, 4]
arr.unshift(0)
console.log(arr) // [0, 2, 3, 4]
```
## 指定位置插入/移除/取代 Array.prototype.splice()
> let arrRemoved = arr.splice(start[, deleteCount[, item1[, item2[, ...]]]]) 

可以說式集移除、插入、取代(移除+插入)於一身的重要函式，並且將被移除的區段做為新陣列回傳，可根據傳入的參數將使用場景分類如下表，可幫助理解：
|               | 添加item         | 不添加item         |
| ------------- |:---------------:| -----------------:|
| deleteCount=0 | 在現有位置添加元素 | (無意義)           |
| deleteCount>0 | 取代現有元素      | 範圍移除元素        |

### 範圍移除元素
```js
const arr=[0, 1, 2, 3, 4, 5, 6]
// 移除索引位置3的元素，移除範圍為1
let removed = arr.splice(3, 1)
console.log(removed) // [3]
console.log(arr) // [0, 1, 2, 4, 5, 6]
```

### 在現有位置添加元素
```js
const arr=[0, 1, 2, 3, 4, 5, 6]
// 移除索引位置3的元素，移除範圍為0，並且插入3.1, 3.2
let removed = arr.splice(3, 0, 3.1, 3.2)
// 這時候獲得的 removed 為空陣列
console.log(removed) // []
// 插入的元素從索引位置3的地方開始
console.log(arr) // [0, 1, 2, 3.1, 3.2, 3, 4, 5, 6]
```

### 取代現有元素
```js
const arr=[0, 1, 2, 3, 4, 5, 6]
// 移除索引為3的元素，移除長度範圍為2
// 並且插入元素 10, 11, 12
let removed = arr.splice(3, 2, 10, 11, 12)
console.log(removed) // [3, 4]
console.log(arr) //  [0, 1, 2, 10, 11, 12, 5, 6]
```

## 複製陣列內特定區塊至特定位置 Array.prototype.copyWithin()
> arr.copyWithin(target[, start[, end]])
```js
const arr = [1, 2, 3, 4, 5];

// 將索引3-4之間的區塊("4")貼到索引0(取代0)
console.log(arr.copyWithin(0, 3, 4)); // [4, 2, 3, 4, 5]

// 將索引3到結束之間的區塊(4, 5)貼到索引1(取代1,2)
console.log(arr.copyWithin(1, 3)); // [4, 4, 5, 4, 5]
```

## 全部或指定位置填滿 Array.prototype.fill()
> arr.fill(value[, start[, end]])

把陣列內全部的元素，或指定的索引範圍以特定值填滿
- 如果傳入的值是物件，會以物件的參照填滿
- 如果給定的索引 index 或 end 是負值，則以 arr.length+index 計算
```js
// 全部填滿
[1, 2, 3].fill(4);               // [4, 4, 4]
// 指定位置以後填滿給定的值
[1, 2, 3].fill(4, 1);            // [1, 4, 4]
// 指定範圍填滿
[1, 2, 3].fill(4, 1, 2);         // [1, 4, 3]
// 若為負值則自動加上長度(只會加一次)，因此(4, -3, -2)等於(4, 0, 1)
[1, 2, 3].fill(4, -3, -2);       // [4, 2, 3]
// 指定範圍超出長度則無作用
[1, 2, 3].fill(4, 3, 5);         // [1, 2, 3]
// NaN 無效
[1, 2, 3].fill(4, NaN, NaN);     // [1, 2, 3]
[].fill.call({ length: 3 }, 4);  // {0: 4, 1: 4, 2: 4, length: 3}

// 物件複製的是參照，指向同一物件
let arr = Array(3).fill({}) // [{}, {}, {}];
arr[0].hi = "hi"; // [{ hi: "hi" }, { hi: "hi" }, { hi: "hi" }]
```

## 元素反轉 Array.prototype.reverse()
> arr.reverse()
```js
let a = [1, 2, 3];
let b = a.reverse(); 

console.log(a);  // [3, 2, 1]
console.log(b); // [3, 2, 1]
// 回傳的陣列指向被反轉的原本陣列
a===b  // true
```

## 元素排序 Array.prototype.sort()
> arr.sort([compareFunction]) 

對陣列進行 in place 排序，且回傳原陣列，如果不給定 compareFunction 則預設依據字串 Unicode 編碼進行比對後進行升冪排序，但根據環境實作不同時間/空間複雜度也不同，且各環境下同一陣列的排序結果也不一定相同。
- compareFunction(a, b) > 0: 把 b 排在 a 之前。
- compareFunction(a, b) = 0: 不改變排序。
- compareFunction(a, b) < 0: 把 a 排在 b 之前。

```js
// 預設是升冪排序
[2, 1, 3].sort() // [1, 2, 3]
// 針對物件排序
let objs = [
  { key: 'Peter', value: 36 },
  { key: 'Vicky', value: 35 },
  { key: 'Red', value: 37 },
  ...
];

// 根據 value 屬性排序
objs.sort(function (a, b) {
  return a.value - b.value;
});

// 根據 name 排序
items.sort(function(a, b) {
  // 一般來說忽視大小寫
  let keyA = a.key.toUpperCase(); 
  let keyB = b.key.toUpperCase();
  if (keyA < keyB) {
    return -1;
  }
  if (keyA > keyB) {
    return 1;
  }

  // names must be equal
  return 0;
});
```
P.S. 如果進行大量排序操作可轉為Map排序後再轉回陣列，效能較好 (詳見MDN)

## 處理每個元素 Array.prototype.forEach()
> arr.forEach(function callback(currentValue[, index[, array]]) {}[, thisArg]);

對每個陣列元素傳入並執行給定的 callback 函式，forEach 是 blocking 操作，但每個 callback 是並行執行無法區分先後順序！如果要循序執行必須要加以改造，或是改用 for…of，只有在每個 callback 彼此間沒有依賴關係時才使用 forEach。

# 取值/求值
## 取得陣列長度 Array.length
## 從開頭或特定位置取得元素首次出現的索引 Array.prototype.indexOf()
> arr.indexOf(searchElement[, fromIndex])
## 取得元素 最後出現的索引 Array.prototype.lastIndexOf()
> arr.lastIndexOf(searchElement[, fromIndex]) 
## 取得滿足回呼函式的索引 Array.prototype.findIndex()
> arr.findIndex(callback[, thisArg])
## 取得符合判斷式的第一個元素值 Array.prototype.find()
> arr.find(callback[, thisArg])
## 執行 reducer function 取值 Array.prototype.reduce()
> arr.reduce(callback[accumulator, currentValue, currentIndex, array], initialValue)

reducer 接收一個 callback 並且對每個第一個之外的每個元素執行 callback (如果有提供 initialValue 則也會將第一個元素納入計算)，callback 函式參數如下：
- accumulator：callback 函式上次回傳的結果
- currentValue：目前正在處裡的陣列元素。
- currentIndex：目前陣列元素的索引，如果沒有提供 initialValue 的時候從1開始，否則從 0 開始。
- array：正在處裡的陣列。
- initialValue：提供起始值讓第一個元素可以納入計算。

如果沒有提供 initialValue，累加時的型別判定不好掌握，時常產生預期之外的結果，因此最好習慣總是提供 initialValue，並且需注意 accumulator、currentValue 作為函示取值時是否為正確的型別。

```js
maxCallback = ( acc, cur ) =>{
    let max = Math.max(acc.x, cur.x)
    console.log("acc: " + acc +", cur: " + cur + ", max: " + max)
    return max 
}
[ { x: 2 }, { x: 22 }, { x: 42 } ].reduce( maxCallback ); 
// 第一輪輸出正缺判定 acc.x, cur.x
// acc: [object Object], cur: [object Object], max: 22
// 第二輪 acc 實際上為 22，所以22.x=NaN，Math.max(NaN, 42)=NaN
// acc: 22, cur: [object Object], max: NaN
// 第三輪之後 acc 基本上就是 NaN
```
良好的習慣：

- 提供初始值。
- 以轉型函示(如 map )將要累計的值導出至新的 array 避免 callback 從物件中取值，新陣列再進行 reduce。
```js
maxCallback = ( acc, cur ) =>{
    return Math.max(acc, cur) 
}
[ { x: 2 }, { x: 22 }, { x: 42 } ]
    .map( el => el.x )
    .reduce( maxCallback, -Infinity );
// 42
```
## 反向執行 reducer function 取值 Array.prototype.reduceRight()
> arr.reduceRight(callback(accumulator, currentValue[, index[, array]])[, initialValue])
## 取得以分隔符號連接元素的字串 Array.prototype.join()
> arr.join([separator])

以分隔符號合併陣列中所有的元素成一個字串並回傳，分隔符號預設為’,’。

```js
// 使用預設的分隔符號 ','
[1,2,3,4,5].join() // "1,2,3,4,5"
// 不使用分隔符號
[1,2,3,4,5].join('') // "12345"
// 指定其他分隔符號
[1,2,3,4,5].join('_') // "1_2_3_4_5"
```
## 取得表示該陣列的字串 Array.prototype.toString()
> arr.toString()

取得該陣列的文字描述，效果跟 arr.join() 一樣。
```js
[1,2,3,4,5].toString() // "1,2,3,4,5"
```
# 取得新陣列
## 陣列建構方法 Array()、Array.of()
> let arr1 = new Array([capacity]);  
> let arr2 = Array.of(element0[, element1[, ...[, elementN]]])

```js
new Array(5); // [empty × 5]
Array.of(1,2,3,4,5) // [1, 2, 3, 4, 5]
```

## 取得從字串、陣列產生的新陣列，可加入元素轉換函式 Array.from()
> Array.from(arrayLike [, mapFn [, thisArg]])

從 array-like/iterable object 如 string、set、map、arguments獲得 shallow-copied 的陣列。

```js
// 拆解字串產生 Array
Array.from('foo') // [ "f", "o", "o" ];

// 將 set 轉為陣列，這裡會自動去掉一個重複的 foo 
const set = new Set(['foo', 'bar', 'baz', 'foo']);
Array.from(set); // ["foo", "bar", "baz"]

// 將 map、map.values、map.keys 轉為陣列
const map = new Map([['1', 'a'], ['2', 'b']]);
Array.from(map); // [[1, a], [2, b]]
Array.from(map .keys()); // ['1', '2']
Array.from(map .values()); // ['a', 'b']

// 從函式的引數獲得陣列
let args=[];
function f(){
  args = Array.from(arguments)
}
f(1,2,3)
args.toString() // "1,2,3"
```

## 從特定區段產生新陣列 Array.prototype.slice()
> arr.slice([begin[, end]])

```js
[0, 1, 2, 3, 4, 5].slice(2, 4) // [2, 3]
```
## 取得元素滿足回呼函式的新陣列 Array.prototype.filter()
> let newArray = arr.filter(callback(element[, index[, array]])[, thisArg])
```js
const arr = [0, 1, 2, 3, 4, 5, 6]
const newArr = arr.filter(e => e % 2 === 0)
newArr // [0, 2, 4, 6]
```

## 取得串接多個陣列後的新陣列 Array.prototype.concat()
> let new_array = old_array.concat(value1[, value2[, ...[, valueN]]])
```js
const arr = [0, 1, 2, 3]
const arr1 = [4, 5, 6]
const arr2 = [7, 8, 9]

const arrConcat = arr.concat(arr1, arr2)
// arr 並沒有改變，串聯的陣列是新陣列
arr // [0, 1, 2, 3]
arrConcat // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

## 取得每個元素轉換後的新陣列 Array.prototype.map()
> let new_array = arr.map(function callback( currentValue[, index[, array]]) {
    // 回傳作為新陣列的元素
}[, thisArg])
```js
const arr = [0, 1, 2, 3, 4, 5, 6]
const newArr = arr.map(e => e * 2)
newArr // [0, 2, 4, 6, 8, 10, 12]
```

## 取得多維陣列攤平後的新陣列 Array.prototype.flat()
>let newArray = arr.flat([depth]);

Array.prototype.flat() 會自動清除空元素，並展開指定深度的巢狀陣列，深度預設值為 1。
```js
// arr1 深度為1，所以不指定深度就能攤開
let arr1 = [1, 2, [3, 4]];
arr1.flat(); // [1, 2, 3, 4]

// arr2 深度為2，因此需指定深度才能完整攤開
let arr2 = [1, 2, [3, 4, [5, 6]]];
arr2.flat(); // [1, 2, 3, 4, [5, 6]]
arr2.flat(2); // [1, 2, 3, 4, 5, 6]
```

## 取得多維陣列以回呼函式攤平後的新陣列 Array.prototype.flatMap()
> var new_array = arr.flatMap(function callback(currentValue[, index[, array]]) {  
>    // 回傳作為新陣列的元素  
> }[, thisArg])

arr.flatMap(func) 的效果等於 arr.map(func).flat() 但效能較佳，不過攤開深度只能是1，當 map() 回傳的元素是陣列且需要透過 flate() 攤開呈現最終結果時，可改用 flateMap()，例如從”句子”陣列獲得”單字”陣列：

```js
// 假設要從句子陣列獲得單字的一維陣列
let arr1 = ["animal cell", "have", "mitochondria"];

// 使用 map 處裡會獲得二維陣列，必須再串聯一次 flat()
arr1.map(x => x.split(" ")); // [["animal","cell"],["have"],["mitochondria"]]
arr1.map(x => x.split(" ")).flat(); // ["animal ","cell","have", "mitochondria"]

// flatMap 效果等價於 map().flat()，但效能更佳
arr1.flatMap(x => x.split(" ")); // ["animal ","cell","have", "mitochondria"]
```

# 判斷
## 判斷該物件是否為陣列 Array.isArray()
Array.isArray(obj)
## 判斷陣列的每個元素是否皆滿足判斷函式 Array.prototype.every()
arr.every(callback[, thisArg])
## 判斷陣列是否有至少一個元素滿足判斷函式 Array.prototype.some()
arr.some(callback[, thisArg])
## 判斷陣列是否包含某元素值 Array.prototype.includes()
arr.includes(searchElement[, fromIndex])

# Reference
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array