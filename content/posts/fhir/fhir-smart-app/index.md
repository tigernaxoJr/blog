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
## 介紹
### 使用情境

SMART App Launch Framework 中 OAuth 2.0 裡面的資源擁有者被稱為 user，涉及的腳色如下：
 - `Resource Owner` (`user`)：操作 EHR 的人，可能是醫生、病患和其他使用者。
 - `Resource Server`：存放資源的伺服器。
 - `Authorization Server`：`基於 OAuth 2.0` 的授權伺服器。
 - `client`：由 EHR 開啟的第三方應用程式，會嘗試透過 EHR 向授權伺服器取得授權。
 - `EHR`：和電子健康紀錄(Electronic Health Record)有關的應用程式，可以是個人健康紀錄(PHR)、病患入口網站、任何支援 FHIR 系統的平台，負責將實體的權限（例如用戶的權限）委託給第三方應用程序。

依據 `user`、`cilent` 啟動方式區分為四種使用情境：
 - 使用者為`病患`，`獨立啟動`的 App。
 - 使用者為`病患`，`從入口網站啟動`的 App。
 - 使用者為`醫療服務提供者`，`獨立啟動`的 App。
 - 使用者為`醫療服務提供者`，`從入口網站啟動`的 App。

### 目的
SMART App Launch Framework 目的在於提供：
 - 定義一個在 EHR 現有用戶和權限管理系統之上，將實體權限（例如用戶的權限）委託給第 3 方應用程序的機制。
 - 讓使用者終端設備或安全伺服器上使用的應用程式(`client`)請求授權(authorize)、身份驗證(authenticate)的授權協定 (protocol)
 - 與 FHIR 的數據系統整合的指引，相容於`FHIR 試用標準草案第二版` (`FHIR R2 (DSTU2)`) 及之後的版本。   

**沒有**提供什麼：
 - 企業認證政策，包含請求終端使用者授權。(各企業不同)
 - 美國 HIPAA（健康保險可攜性與責任法案）要求的安全機制 ([HIPAA Compliant Software](http://whatishipaa.org/hipaa-compliant-software.php))
 - patient context 同步(需參照 FHIRcast)
 - 限制用戶權限模型(沒有提供任何機制定義被授權 App 應該或不應該能夠訪問 EHR 中的特定記錄)

### Terminology 
 - EHR：Electronic Health Record
 - STU：Standard for Trial Use
 - DSTU2：The Second Draft Standard for Trial Use
 - PHR：個人健康紀錄

## 啟動與授權(Launch and Authorization)
Launch and Authorization 


### 安全性(Security and Privacy Considerations)
### App 保護安全標準
基於 [RFC6819 - OAuth 2.0 Threat Model and Security Considerations](https://datatracker.ietf.org/doc/html/rfc6819) ：
 - 傳輸`敏感性資料`的時候只能透過 `TLS` (就是 HTTPS) 傳輸給`信任的伺服器`。
 - App 應生成一組不可預測的狀態參數 ([`state`](https://datatracker.ietf.org/doc/html/rfc6819#section-5.3.5)) 並夾帶在所有授權請求當中，當應用程式從授權伺服器重新導向回來的時候，應檢查狀態參數是否和先前生成的匹配，這是為了防止 CSFR  
    > (大意：類似 CSFR token 的概念)。
 - App 不應將將不受信任的使用者輸入作為程式執行。  
    > 大意：防止各種 injection
 - 應用程式透過 `redirect URL` 回到應用程式後，`不得`將URL參數，轉發到任何其他隨意或使用者提供的URL
    > 為了防止 開放式重定向 `open redirector` 攻擊。
 - `不得`將 token 存儲在以明文傳輸的 cookie 中。
 - `應該`只將 token 和其他敏感資料持久化存儲在專屬於應用程式的存儲位置中，`不應該`存儲在系統範圍可被發現的位置。

### Client 密鑰保護 
參照 [ OAuth 2.0 specification: confidential and public](https://tools.ietf.org/html/rfc6749#section-2.1)，應用程式分為兩種類型：
- `confidential app`
  > 執行環境能夠保護密鑰的應用程序，例如：
  > - 在受信任的`伺服器運行`，只有伺服器端才能訪問密鑰。
  > - 使用`附加技術保護秘密`的`本機應用程序`（例如動態客戶端註冊和通用redirect_uris）。
- `public app`  
  > 執行環境不能夠保護密鑰的應用程序
純客戶端應用程序，**可提供足夠的安全性**，但它們可能**無法保護密鑰"**，應用程序中`靜態嵌入的密鑰`、代碼或字符串都可能被最終用戶或攻擊者`提取`。因此這些應用程序的驗證不能依賴於安裝時嵌入的密鑰，例如：
  > - 基於 HTML5/JS 的瀏覽器應用程序
  > - 移動裝置應用程序 
  > - Windows 桌面應用程序

#### Authorization Code with PKCE
"Authorization Code with PKCE" 流程，即 Proof Key for Code Exchange，這個流程在不需要 client_secret 的情況下提供了額外的安全性。  
在 OAuth 2.0 的標準授權流程中，攻擊者可能會嘗試攔截網頁上的授權請求取得授權碼，並使用該授權碼來換取存取 token。這是因為在傳統的 "Authorization Code" 流程中，只需要授權碼本身，不需要額外的驗證。
PKCE 確保授權碼只能由 client （ex: SPA）取得，因為攻擊者只能攔截 code_challenge 不會知道 code_verifier ，故攻擊者無法成功換取 token。
public app 無法儲存 client_secret，需要使用 PKCE，Web 的 具體流程：
1. client 產生 `code_verifier` 和 `code_challenge`， client 儲存 `code_verifier`。
2. client 將 `code_challenge` (和對應的演算法)附在網址一起給 `authentication server`
3. `authentication server` 記得 `code_challenge`，把 `authentication_code` 給 client
4. client 使用 `authentication_code` 和 `code_verifier` 和 `authentication server` 交換 token

OAuth 2.0 授權伺服器負責處理驗證過程並在驗證流程中驗證 client_id 和 code_challenge。client_id 用於識別您的 SPA，而 code_challenge 則提供了一種安全的方式來驗證授權碼是來自您的 SPA。
 - code_challenge 
 - code_verifier


## 授權範圍與啟動上下文(Scopes and Launch Context)

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
- [ medium - 網站安全🔒 開放式重定向 Open Redirect 攻擊手法 — 「導遊放你自由行」](https://medium.com/%E7%A8%8B%E5%BC%8F%E7%8C%BF%E5%90%83%E9%A6%99%E8%95%89/%E7%B6%B2%E7%AB%99%E5%AE%89%E5%85%A8-%E9%96%8B%E6%94%BE%E5%BC%8F%E9%87%8D%E5%AE%9A%E5%90%91-open-redirect-%E6%94%BB%E6%93%8A%E6%89%8B%E6%B3%95-68c745b53a3b)
 - [ OAuth 2.0 specification: confidential and public](https://tools.ietf.org/html/rfc6749#section-2.1)
 - [RFC6819 - OAuth 2.0 Threat Model and Security Considerations](https://datatracker.ietf.org/doc/html/rfc6819)
- [RFC7636 - Proof Key for Code Exchange by OAuth Public Clients](https://datatracker.ietf.org/doc/html/rfc7636)
- [auth0.com - Authorization Code Flow with Proof Key for Code Exchange (PKCE)](https://auth0.com/docs/get-started/authentication-and-authorization-flow/authorization-code-flow-with-proof-key-for-code-exchange-pkce#how-it-works)