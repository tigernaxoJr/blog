---
title: "[FHIR] SMART App Launch Framework"
date: 2023-07-10T16:11:00+08:00
draft: true
hero: 
menu:
  sidebar:
    name: "[SMART] App Launch"
    identifier: fhir-smart-01app
    parent: fhir 
    weight: 2001
---
# SMART App Launch Framework
## OverView
### 腳色釐清
 - `Authorization Server`：`基於 OAuth 2.0` 的授權伺服器。
 - `EHR`：和電子健康紀錄(Electronic Health Record)有關的應用程式，可以是個人健康紀錄(PHR)、病患入口網站、任何支援 FHIR 系統的平台，負責將實體的權限（例如用戶的權限）委託給第三方應用程序。
 - `user`：可能是醫生、病患和其他使用者，操作 EHR 的人。
 - `client`：由 EHR 開啟的第三方應用程式，會嘗試透過 EHR 向授權伺服器取得授權。

依據使用者、啟動方式分為四種使用案例：
 - 使用者為`病患`，`獨立啟動`的 App。
 - 使用者為`病患`，`從入口網站啟動`的 App。
 - 使用者為`醫療服務提供者`，`獨立啟動`的 App。
 - 使用者為`醫療服務提供者`，`從入口網站啟動`的 App。

### 功能
提供什麼：
 - 授權協議 (protocol)，讓使用者終端設備或安全伺服器上使用的應用程式(`client`)請求授權(authorize)、身份驗證(authenticate)
 - 定義一個在 EHR 現有用戶和權限管理系統之上，將實體的權限（例如用戶的權限）委託給第 3 方應用程序的機制。
 - 與 FHIR 的數據系統整合的指引，相容於`FHIR 試用標準草案第二版`(`FHIR R2 (DSTU2)`) 及之後的版本。  
`沒有`提供什麼：
 - 企業認證政策，包含請求終端使用者授權。(各企業不同)
 - 美國 HIPAA（健康保險可攜性與責任法案）要求的安全機制 ([HIPAA Compliant Software](http://whatishipaa.org/hipaa-compliant-software.php))
 - patient context 同步(需參照 FHIRcast)
 - 限制用戶權限模型(沒有提供任何機制定義被授權 App 應該或不應該能夠訪問 EHR 中的特定記錄)

Terminology. 
 - EHR：Electronic Health Record
 - STU：Standard for Trial Use
 - DSTU2：The Second Draft Standard for Trial Use
 - PHR：個人健康紀錄

## Launch and Authorization
Launch and Authorization 


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
- [HIPAA Compliant Software](http://whatishipaa.org/hipaa-compliant-software.php)