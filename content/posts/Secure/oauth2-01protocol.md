---
title: "[授權] OAuth 2.0 Authorization Framework"
date: 2023-07-16T00:25:00+08:00
draft: false
hero:
menu:
  sidebar:
    name: "[授權] OAuth 2.0 簡介"
    identifier: secure-oauth20
    parent: secure
    weight: 1000
---

## 介紹 Introduction

OAuth 是一套授權框架，讓第三方應用程式(被授權方)不需取得原始帳號、密碼等敏感資訊，獲得有限的權限以存取資源，目前版本為 2.0。
運作方式為`授權伺服器`發放 `token`給`第三方應用`，token 上記載相關權限範圍(scope)，`資源伺服器`需要權限存取時`第三方應用`再把 token 出示給系統驗證。

### 腳色(Roles)

- `授權伺服器 (Authorization Server)`：負責管理使用者授權的伺服器。
- `資源伺服器 (Resource Server)`：儲存資源的伺服器。
- `第三方應用程式 (Third-Party Application)`：需要存取資源的應用程式。
- `使用者 (User)`：授權第三方應用程式存取其資源的使用者。

### RFC 規範

- RFC 6749  
  是 OAuth 2.0 的核心規範，描述了 OAuth 2.0 的`授權框架`和`授權流程`。
- RFC 6750  
  OAuth 2.0 的另一個相關規範，定義了用於訪問受保護資源的`身份驗證方法`，規範包括 Bearer Token 的身份驗證。

<!-- ### 協定流程 -->

<!-- todo: flow -->

## Reference

- [RFC 6749](http://www.rfcreader.com/#rfc6749)
