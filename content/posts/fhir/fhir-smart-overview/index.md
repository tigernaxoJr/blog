---
title: "[FHIR] SMART Health IT"
date: 2023-07-10T16:11:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[SMART] Overview"
    identifier: fhir-smart-00overview
    parent: fhir 
    weight: 2000
---
## Overview
[SMART Health IT](https://smarthealthit.org/) 最早在《新英格蘭醫學雜誌》的一篇文章中推出，提出`編寫一次應用程序，然後讓它在醫療保健系統的任何地方運行`，制定通用 API。
SMART 已成為 `21st Century Cures Act`和`2020 Final Rule from the ONC`認證要求項目。
## Pre-erequirement
需要先熟悉 OAuth 2.0 的流程。  
## Discovery document 
SMART 定義了一個標準的 metadata 端點 `/.well-known/smart-configuration` 稱為 discovery document 
用來告訴使用者仲介訊息：
 - Server Capabilities (server 可以做什麼)
 - Configuration (配置?)

## 認證與授權
### 授權(Authorization)
SMART 定義兩種 Client 端 App `授權`模式，差別主要在於被授權是否有使用者參與：
 - Authorization via SMART App Launch  
    透過 1.EHR 或其他健康軟體的登入 session 或2.使用者手動授權，將用戶權限委託給`面向使用者的 App`本身連接到 FHIR Server 存取資源，被授權方獲得授權方分向的資訊稱為 `lanuch context` (例如用戶資訊)。
 - Authorization via SMART Backend Services  
   授權在與用戶無關的情況下完成。
### 認證(Authentication)
SMART 定義兩種 Client 端 App `認證`模式，也就是對稱/不對稱加密，官方建議是使用不對稱加密：
 - Asymmetric (“private key JWT”) authentication
 - Symmetric (“client secret”) authentication
### 範圍(scopes)
SMART 的`scopes`允許 client 程式請求委派(delegate)一組特定的訪問權限，而委派的權限所受到的限制來自兩種機制：
 - 底層系統政策(policy)  
   假如 client 使用 `SMART App Launch` 向使用者請求 `user/*.cruds` scope，使用者授予後 client 
 - 底層系統本身權限(permission)的限制。  

使用 `scopes` 限制被授權的 client 可存取範圍
例如： 
 - SMART App Launch 的程式被授權 `user/Encounter.rs` 可讀取、搜尋`授權使用者`(launch context)可存取的 Encounter 資源。
 - SMART Backend Services 的程式被授權 `system/Encounter.rs` 可讀取、搜尋該 App `全部或被設定可存取`的 Encounter 資源。  

例如最常見的 Scope:
| Scope               | 權限                                                                  |
| ------------------- | --------------------------------------------------------------------- |
| patient/*.rs        | 可以對屬於`當下病患(patient)`的`任何資源(*)`進行`搜尋/讀取(rs)`       |
| user/*.cruds        | 可以對屬於`當下使用者(user)`的`任何資源(*)`進行`搜尋和CRUD(cruds)`    |
| openid <br>fhirUser | 可以存取`當前登入的使用者(user)`資訊                                  |
| launch              | 當 app `從 EHR 啟動`，app `獲得 launch context`                       |
| launch/patient      | 當 app `不是從 EHR 啟動`，app `在啟動時請求選擇患者`(?)               |
| offline_access      | 可申請一組即使 `access token 失效、使用者離線仍有效`的`refresh_token` |
| online_access       | 可申請一組需`使用者在線才有效`的`refresh_token`                       |

## Token Introspection
SMART 流程中，`Authorization Server` 需要定義一個 Token Introspection API，用來檢查 token 的 scopes、用戶、病患、等等 token 詳細訊息，透過這個模式讓 `Resource Server` 和 `Authorization Server` 解耦。  
實作可以參考 [RFC7662 - OAuth 2.0 Token Introspection](https://datatracker.ietf.org/doc/html/rfc7662)。
### Request
請求範例：使用`POST`、需要使用者驗證。
```
POST /introspect HTTP/1.1
Host: server.example.com
Accept: application/json
Content-Type: application/x-www-form-urlencoded
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW

token=mF_9.B5f-4.1JqM&token_type_hint=access_token
```
參數說明:
| 欄位            | 必要 | 說明           |
| --------------- | ---- | -------------- |
| token           | 必要 | token 本人     |
| token_type_hint | 選用 | token 類型提示 |

### Response
回應範例：`JSON`
| 欄位       | 必要     | 說明                                      |
| ---------- | -------- | ----------------------------------------- |
| active     | REQUIRED | token 是否可用                            |
| scope      | OPTIONAL | 授權範圍                                  |
| client_id  | OPTIONAL | 要求授權的 client (SMART App)             |
| username   | OPTIONAL | user ID                                   |
| token_type | OPTIONAL | token 類型(access/refresh..)              |
| exp        | OPTIONAL | expiration time `(JWT Registered Claims)` |
| iat        | OPTIONAL | issued at `(JWT Registered Claims)`       |
| nbf        | OPTIONAL | not before `(JWT Registered Claims)`      |
| sub        | OPTIONAL | subject `(JWT Registered Claims)`         |
| aud        | OPTIONAL | audience `(JWT Registered Claims)`        |
| iss        | OPTIONAL | issuer `(JWT Registered Claims)`          |
| jti        | OPTIONAL | JWT ID `(JWT Registered Claims)`          |

## Reference
- [SMART](https://smarthealthit.org/)
- [SMART App Launch](https://build.fhir.org/ig/HL7/smart-app-launch/toc.html)
- [iThome - 簡介其他 OpenID Connect 協定的內容](https://ithelp.ithome.com.tw/articles/10227389)
- [RFC7662 - OAuth 2.0 Token Introspection](https://datatracker.ietf.org/doc/html/rfc7662)
- [iThome - Revocation 與 Introspection](https://ithelp.ithome.com.tw/articles/10226911)