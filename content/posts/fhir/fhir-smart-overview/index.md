---
title: "[FHIR] SMART Health IT"
date: 2023-07-10T16:11:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[FHIR] SMART Health IT"
    identifier: fhir-smart-00overview
    parent: fhir 
    weight: 1000
---
[SMART Health IT](https://smarthealthit.org/) 最早在《新英格蘭醫學雜誌》的一篇文章中推出，提出`編寫一次應用程序，然後讓它在醫療保健系統的任何地方運行`，制定通用 API。
SMART 已成為 `21st Century Cures Act`和`2020 Final Rule from the ONC`認證要求項目。
## Pre-erequirement
先熟悉 OAuth 2.0 的流程。  
## Overview
### Discovery document 
SMART 定義了一個標準的 metadata 端點 `/.well-known/smart-configuration` 稱為 discovery document 
用來告訴使用者仲介訊息：
 - Server Capabilities 
 - Configuration
### Authorization
SMART 定義兩種 Client 端 App `授權`模式，差別主要在於被授權是否有使用者參與：
 - Authorization via SMART App Launch  
    透過 1.EHR 或其他健康軟體的登入 session 或2.使用者手動授權，將用戶權限委託給`面向使用者的 App`本身連接到 FHIR Server 存取資源，被授權方獲得授權方分向的資訊稱為 `lanuch context` (例如用戶資訊)。
 - Authorization via SMART Backend Services  
   授權在與用戶無關的情況下完成。
### Authentication
SMART 定義兩種 Client 端 App `認證`模式，也就是對稱/不對稱加密，官方建議是使用不對稱加密：
 - Asymmetric (“private key JWT”) authentication
 - Symmetric (“client secret”) authentication
### scopes
使用 `scopes` 限制被授權的 client 可存取範圍
例如： 
 - SMART App Launch 的程式被授權 `user/Encounter.rs` 可讀取、搜尋`授權使用者`(launch context)可存取的 Encounter 資源。
 - SMART Backend Services 的程式被授權 `system/Encounter.rs` 可讀取、搜尋該 App `全部或被設定可存取`的 Encounter 資源。
### Token Introspection
SMART 定義一個 Token Introspection API，用來檢查 token 的 scopes、用戶、病患、等等前後文訊息，透過這個模式讓 `Resource Server` 和 `Authorization Server` 解耦。


## Reference
- [SMART](https://smarthealthit.org/)
- [SMART App Launch](https://build.fhir.org/ig/HL7/smart-app-launch/toc.html)
- [iThome - 簡介其他 OpenID Connect 協定的內容](https://ithelp.ithome.com.tw/articles/10227389)