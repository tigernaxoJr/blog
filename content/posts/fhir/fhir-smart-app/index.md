---
title: "[FHIR] SMART App Launch Framework"
date: 2023-07-10T16:11:00+08:00
draft: true
hero: 
menu:
  sidebar:
    name: "[FHIR] SMART App Launch"
    identifier: fhir-smart-01app
    parent: fhir 
    weight: 1000
---
SMART App Launch 提供一份供 Client 端應用程序基於 OAuth 2.0 進行授權(authorize)、身份驗證(authenticate)、以及與 FHIR 的數據系統整合的指引。
STU for "Standard for Trial Use."
## Launch and Authorization
Launch and Authorization 
 - `定義`一個在 EHR 現有用戶和權限管理系統之上，將實體的權限（例如用戶的權限）委託給第 3 方應用程序的機制。
 - `沒有`限制用戶權限模型(沒有提供任何機制定義被授權 App 應該或不應該能夠訪問 EHR 中的特定記錄)

四種 use case：
 - `Patients` apps that launch `standalone`
 - `Patient` apps that launch `from a portal`
 - `Provider` apps that launch `standalone`
 - `Provider` apps that launch `from a portal`

### Security and Privacy Considerations
 - 傳輸`敏感性資料`的時候只能透過 `TLS` (就是 HTTPS) 傳輸給`信任的伺服器`。
 - App 應生成一組不可預測的狀態參數(state parameter)並夾帶在所有授權請求當中，當應用程式從授權伺服器重新導向回來的時候，應檢查狀態參數是否和先前生成的匹配，這是為了防止 CSFR  
    > (大意：類似 CSFR token 的概念)。
 - App 不應將將不受信任的使用者輸入作為程式執行。
  > 大意：防止各種 injection

## Scopes and Launch Context









## 一致性onformance)
是擴充 `OpenID Connect Discovery` 而來，
### OpenID Connect Discovery
metadata 端點 `/.well-known/openid-configuration`
### SMART 
metadata 端點`/.well-known/smart-configuration`
### 
## Reference
- [SMART](https://smarthealthit.org/)
- [SMART App Launch](https://build.fhir.org/ig/HL7/smart-app-launch/toc.html)
- [iThome - 簡介其他 OpenID Connect 協定的內容](https://ithelp.ithome.com.tw/articles/10227389)