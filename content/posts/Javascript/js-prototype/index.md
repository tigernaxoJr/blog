---
title: "[JS] JavaScript 當中的原型繼承鏈模型"
date: 2020-05-20T09:37:18+08:00
hero: 
menu:
  sidebar:
    name: "[JS]原型繼承鏈模型"
    identifier: js-prototype
    parent: Javascript
    weight: 1000
---
# 基於原型 (Prototype-Based) 的 JavaScript
一般物件導向式(OOP; Object Oriented Programming) 程式語言 (如：java、c++、c#) 當中的物件是由類別模板 (class) 產生實體物件 (instance)，實體物件的屬性各自獨立。類別模板上可設置共用的靜態資源包含靜態方法 (static method)、靜態屬性 (static field)，而這些靜態資源可以在沒有建立實體的情況下透過類別名稱直接取用。

JavaScript 中的物件通常隸屬於另一個物件，這種隸屬關係類似物件導向語言的繼承，而在這種關係中的上層物件稱為原型 (Prototype)。原型本身又有自己所屬的原型，這種物件層層繼承的關係稱為原型鏈 (Prototype Chain)，幾乎所有物件的最上層原型是一個構造函數叫做 Object 的物件。

因此一般物件導向式語言稱為基於類別 (Class-Based) 的語言；而 Javascript 是基於原型 (Prototype-Based) 的語言。

# 建立物件原型
JavaScript 本身沒有類別模板的概念，是以構造函數 (constructor) 建立物件，物件可以將 constructor 屬性指向構造函數，但並非所有物件都有構造函數，具有構造函數的物件可直接以構造函數產生原型鏈下一層物件；不具有構造函數的物件只能在其他物件建立完成後，以其他方式設置為其他物件的原型。

建立原型的方法就是直接宣告一個函數，JavaScript 會自動把該函數作為構造函數，並自動建立一個隸屬於 Object.prototype 之下的匿名物件，並把宣告的函數指定給該匿名物件的 constructor 屬性。

```js
// 宣告一個函數 Foo
function Foo (){}

// Foo.prototype 在 Foo 被宣告時自動建立
Foo.prototype // {constructor: ƒ}
// Foo.prototype 的 constructor 屬性自動指向 Foo
Foo.prototype.constructor === Foo // true
```

# 建立物件

## 透過構造函數
```js
// 建立一個物件
let bar = new Foo{} // {}
```

## 直接對變數賦值
JavaScript 對變數賦值底層行為：以 Object 構造函數建立物件，然後對物件並賦值（故賦值發生在物件建立之後）
```js
// 建立一個物件
let obj = { a: 1} // {a: 1}
// obj 的原型是 Object.prototype
obj.__proto__ === Object.prototype // true
// a: 1 是 obj 擁有的屬性
obj.hasOwnProperty('a') // true
```
## 從沒有構造函數的物件延伸
物件本身沒有構造函數時，可用 Object.create() 將物件作為原型建立其他物件。
```js
// 建立一個物件
let objProto = {}
// 以 objProto  為原型建立一個物件
let obj = Object.create(objProto)
// obj 的原型為 objProto
obj.__proto__ === objProto // true
```
# 取得物件原型
透過直接聲明函數所產生的原型需要透過兩個方法指涉：

## 透過構造函數 prototype 屬性
構造函數物件建立時會取得 prototype 屬性，prototype 屬性指向該構造函數所屬的原型，一般以 [構造函數名稱].prototype 取得該構造函數所屬原型，以便在原型上加入屬性。

## 透過物件 __proto__ 屬性
Object.prototype 原型鏈上的物件可透過兩個屬性存取原型：__proto__、[[Prototype]]。差別在於[[Prototype]]是私有屬性無法由外部存取；__proto__ 屬性是存取[[Prototype]]的外部接口，ES6之後 __proto__ 屬性就被列為 JavaScript 標準，因此可透過[物件].__proto__ 可取得該物件的上層原型。

## 透過 Object.getPrototypeOf()
Object.getPrototypeOf(物件) 可取得物件的原型。

# Object.prototype 原型鏈
JavaScript 定義構造函數時自動產生的”物件(有構造函數)”預設原型是 Object，得到 [Object]-[物件(有構造函數)]-[物件(無構造函數)] 的階層關係。
```js
// Foo 的原型是 Function.prototype
Foo.__proto__ === Function.prototype // true
// Function.prototype 再上去的原型是 Object.prototype
Function.prototype.__proto__ === Object.prototype // true
// Object.prototype 位於原型鏈最最頂層，因此 __prototype 屬性是 null
Object.prototype.__proto__ // null
```
以直接指派物件給變數的方式建立物件，JavaScirpt 會自動使用構造函數 Object 建立物件，得到 [Object]-[物件(無構造函數)] 的階層關係
```js
// 以賦值直接建立的 obj ，原型就是 Object.prototype
obj.__proto__ === Object.prototype // true
```

## Object.prototype 原型鏈關係整理
![img](JavaScript_ObjectChain.png)

# 原型鏈關係判斷
Object.prototype.isPrototypeOf() 用於判斷物件是否為其他物件的原型；而 instanceof 用於判斷物件是否為構造函數產生的實體。

## 判斷物件和物件的關係
```js
function Foo(){}
let bar = new Foo()
// Foo 建立的物件，會以 Foo.prototype 作為物件原型
Foo.prototype.isPrototypeOf(bar) // true
```
## 判斷物件和構造函數的關係
```js
function Foo(){}
let bar = new Foo()
// bar 是構造函數 Foo 建立的物件
bar instanceof Foo // true
```

# 物件屬性與物件資源共用策略
JavaScript 的繼承和物件導向語言規則不同，物件擁有自己的屬性， 但原型鏈上的資源(屬性、方法)都如同是物件自己的屬性一般可透過物件直接存取。

## 屬性優先權
物件本身的屬性存取權優先於原型鏈上的屬性，因此如果嘗試存取物件、原型鏈上名稱相同的屬性會獲得物件屬性，除非明確指出要存取原型上的屬性。因此存取物件屬性時，該屬性可能來自三種方式，以存取權優先順序排列：
- 物件建立後：直接指派給物件的屬性。
- 物件建立時：構造函數上以 this 賦值的物件屬性。
- 原型鍊上的屬性。
```js
function foo(){
    // 物件建立時：構造函數上以 this 賦值的物件屬性
    this.a=2
    this.b=2
}

// 原型上的屬性
foo.prototype.a=1
foo.prototype.b=1
foo.prototype.c=1

let obj = new foo()
// 物件建立後：再指派給物件的屬性
obj.a=3

// 可以看出建立後指派的屬性 a=3 蓋過構造函數內以 this 賦值的屬性 a=2。
obj    // foo {a: 3, b: 2}
// 原型鍊上的屬性 c 不在物件上，但物件仍然可以和自己的屬性一般存取
obj.c  // 1
```

構造函數產生的物件，原型鍊頂層是 Object.prototype，因此 Object.prototype 定義的所有資源（屬性、方法）都可以直接呼叫：

```js
// 宣告一個函數 animal
function animal(){}

// animal 的物件原型上層是 Object
animal.prototype.__proto__ === Object.prototype // true

let deer = new animal()
// animal 建立的 deer 可以直接呼叫 Object.prototype 上定義的 toString()
deer.toString() // "[object Object]"
// deer 呼叫的 toString 實際上就是  Object.prototype.toString
deer.toString === animal.prototype.__proto__.toString // true
```

## 物件資源共用策略
由於原形鏈上的屬性都可被衍生的物件取用， 因此 JavaScript 共用資源的做法是把資源連結到物件原型上，如此一來物件物件時不必擁有自己一份資源，可以往上從物件原型取得，對必須大量產生物件的操作可有效改善效能。

需要注意的是應避免擴充 Object.prototype 或其他 JavaScript 內建的原型（MDN 上歸類為 monkey patching），除非擴充內建原型的目的是 polyfill（使舊版的 JavaScript 引擎支持新功能）。

```js
// 宣告一個構造函數
function foo(){}

// 在原型上加入資源(可以是屬性或方法)
foo.prototype.hello = function(){
    console.log('hello')
}

// 該資源可以從建立的物件直接取得
let obj1 = new foo()
let obj2 = new foo()

obj1.hello()    // "hello"
obj2.hello()    // "hello"

// 並且呼叫的資源 hello 是同一份
obj1.hello === obj2.hello // true

// 在已建立物件上分別註冊的資源，即使完全相同，也不會是同一份
obj1.hello1 = function(){ console.log('hello1') }
obj2.hello1 = function(){ console.log('hello1') }
obj1.hello1 === obj2.hello1 // false
```

## 判斷物件資源所屬
判斷屬性存在於物件或原型鏈上 Object.prototype.hasOwnProperty()

```js
function Foo(){}
// 把 hello 註冊在原型上
Foo.prototype.hello = function(){
    console.log('hello')
}

let bar = new Foo();
// 物件 bar 可以存取原型的函式 hello
bar.hello(); // hello
// hello 不是 bar 自己的資源
bar.hasOwnProperty('hello') // false
// hello 是原型的資源
Foo.prototype.hasOwnProperty('hello') // true
```
## 原型鏈函數資源中的 this
JavsScript 中 函數的 this 指向呼叫函數的物件，因此物件呼叫原型上的函數時，原型上的函數內如果有關鍵字 this ，則會指向物件本身，而非函數所在的原型：

```
function foo(){}
foo.prototype.name = "prototype"
foo.prototype.echo = function(){
    console.log(this.name)
}
// 函數中的 this 關鍵字指向呼叫的物件，因此 this.name 就是 bar.name
bar = new foo();
bar.name = "bar"
bar.echo() // bar
```

# 串聯原型鏈
JavaScript 試圖尋找不存在或位於頂層原型鏈上的資源時，會循原型鏈往上尋找，因此串連的原型鏈過長會影響效能，應適時將原型鏈打斷。

## 延伸原型鏈 Object.create()
```js
let objProto = {}
// 以 objProto 作為原型建立物件 createdObj 
let createdObj = Object.create(objProto )
// 確認 createdObj 的原型是 objProto
createdObj .__proto__ === objProto  // true
```

## 設定物件原型 Object.setPrototypeOf()
MDN 當中提到 Object.setPrototypeOf () 在各瀏覽器中的實作效能並不好，大量使用時應以 Object.create() 代替。

```js
// 宣告兩個物件
let obj1 = { name: "obj1" }
let obj2 = { name: "obj2" }

// 原型鏈中兩個物件都直接建立於 Object.prototype 之下
obj1.__proto__ === Object.prototype //true
obj2.__proto__ === Object.prototype //true

// 將 obj1 設定為 obj2 的原型
Object.setPrototypeOf(obj2, obj1)
obj2.__proto__ === obj1 // true
// 此時 Object.prototype 不再是 obj2 的上層原型
obj2.__proto__ === Object.prototype // false
// 這時候要透過 obj2 取得 Object.prototype 就需要再上溯一層
obj2.__proto__.__proto__ === Object.prototype // true
```
# ES6 物件語法糖 class
ES5/6 後出現的 class 是構造函數的語法糖，與一般 java 中認知的 class 並不相同，需要以原型鏈的概念對照。

## class, extends, constructor, super
```js
class Person {
  constructor(firstName, lastName) {
    this.firstName = firstName;
    this.lastName = lastName;
  }
}
// Person 實際上是建構函數的名稱 
typeof Person // "function"
// Person 所指涉的原型，上層是 Object.prototype
Person.prototype.__proto__ === Object.prototype // true

class Peter extends Person {
  constructor(lastName) {
    // 建構函數 Peter 裡面呼叫物件原型的建構函數 Person 
    super('Peter', lastName);
  }
  // greetings 的 getter
  get name() {
    return this.firstName + ", " + this.lastName;
  }
  // lastName 的 setter
  set lastName (value) {
    this.lastName = value;
  }
}

// Peter 是另一個建構函數，所屬的物件以 Person.prototype 作為原型
Peter.prototype.__proto__ === Person.prototype // true

// peter 接在 Peter.prototype 下
var peter = new Peter();
square.__proto__ === Square.prototype // true
```
## static
Static 語法把資源綁定到構造函數而非原型本身，因 static 資源此需透過構造函數名稱取得，語法糖把函數名稱視為類別名稱，就好比物件導向語言中的靜態資源需要透過類別名稱取得一般。

```js
class Person {
    static isMonkey() {
        return false;
    }
}

let p = new Person()
// 靜態資源 isMonkey 在構造函數上，而非物件原型上
p.__proto__.hasOwnProperty('isMonkey') // false
p.__proto__.constructor.hasOwnProperty('isMonkey') // true

// 無法透過物件直接取用靜態資源
p.isMonkey() 
/* Uncaught TypeError: t.triple is not a function
    at <anonymous>:1:3 */
// 靜態資源必須透過類別(構造函數)名稱取得
Person.isMonkey() // false
```

# Reference
https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Inheritance_and_the_prototype_chain
https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Guide/Details_of_the_Object_Model
https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Reference/Classes