---
title: "[Program] 巢狀結構"
date: 2022-12-11T02:19:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[程式] 巢狀結構"
    identifier: software-quality-nest
    parent: software
    weight: 1000
---
巢狀程式結構會使程式可讀性差、且難以維護，可讀性高的程式碼深度最多不超過三層，嚴格管控程式碼深度的程式設計師又稱為 Never Nester。

## 消除巢狀程式手法：
- Extraction 
- Inversion 
- 依據契約式程式設計，移除不必要判斷

### Extraction 
從複查的結構抽出程式碼
### Inversion 
把跳出函式的判斷移動到最上面
### 依據契約式程式設計，移除不必要判斷
依據契約式程式設計，以程式碼使用者會傳入的參數合法性為前提，移除不必要判斷