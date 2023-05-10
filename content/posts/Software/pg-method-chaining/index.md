---
title: "[Program] 比較 Method chaining、fluent interface、c# 擴充方法"
date: 2023-04-22T20:58:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[程設] 鏈式語法比較"
    identifier: software-pg-method-chaining
    parent: software
    weight: 1000
---
Method chaining、Fluent interface 和 擴充方法(Extension method) 三種雖然相似，但實則為不同的程式設計概念。

## Method chaining
Method chaining 是一種技術，允許在一行程式碼中調用對象的一系列方法。鏈中的每個方法都返回被調用的對象，從而允許在同一個對象上調用下一個方法。這種技術用於創建更可讀和簡潔的代碼。

## Fluent interface
Fluent interface 是一種設計模式，使用方法串鏈創建更具表現力和可讀性的API。
Fluent interface 的目標是使代碼看起來更像自然語言，使其更容易理解和使用。
在 Fluent interface 中，每個方法調用返回一個對象，允許在同一個對象上調用下一個方法。這種技術通常用於庫和框架中，以為開發人員提供更直觀和自然的API。

## 擴充方法
擴充方法是一種在不修改類本身的情況下為現有類添加功能的方法。擴充方法在單獨的靜態類中定義，並像擴展類的方法一樣調用。這允許開發人員在不修改源代碼的情況下為現有類添加功能。擴充方法通常用於為現有類添加實用函數或為無法修改的類（例如第三方庫）添加功能。

# Reference
- [Fluent Interface｜一種程式碼”寫作”風格](https://www.thinkinmd.com/post/2020/03/02/coding-style-of-fluent-interface/)
- [擴充方法 (C# 程式設計手冊)](https://learn.microsoft.com/zh-tw/dotnet/csharp/programming-guide/classes-and-structs/extension-methods)
- [wiki-Method chaining](https://en.wikipedia.org/wiki/Method_chaining)