---
title: "[授權] OAuth 2.0 Authorization Framework"
date: 2023-07-15T00:36:00+08:00
draft: true
hero:
menu:
  sidebar:
    name: "[授權] OAuth 2.0"
    identifier: secure-oauth20
    parent: secure
    weight: 1000
---

## 1. 介紹 Introduction

OAuth 是一套授權框架，讓第三方應用程式(被授權方)不需取得原始帳號、密碼等敏感資訊，獲得有限的權限以存取資源，目前版本為 2.0。
運作方式為`授權伺服器`發放 `token`給`第三方應用`，token 上記載相關權限範圍(scope)，`資源伺服器`需要權限存取時`第三方應用`再把 token 出示給系統驗證。

### 腳色(Roles)

- `授權伺服器 (Authorization Server)`：負責管理使用者授權的伺服器。
- `資源伺服器 (Resource Server)`：儲存資源的伺服器。
- `第三方應用程式 (Third-Party Application)`：需要存取資源的應用程式。
- `使用者 (User)`：授權第三方應用程式存取其資源的使用者。

### Token

- Access token
- Refresh token
  <!-- todo: 把 oauth 2.0 的 section 拆分開來 -->

## 2. 授權許可 (Authorization Grant)

理解前需要先瞭解解幾個名詞：

- `授權碼 (Authorization Code)`：由授權伺服器產生，用於授權第三方應用程式存取資源的授權憑證。
- `存取權杖 (Access Token)`：由授權伺服器產生，用於允許第三方應用程式存取資源的授權憑證。
- `刷新令牌 (Refresh Token)`：由授權伺服器產生，用於重新產生存取權杖的授權憑證。
- `客戶端憑證`：第三方應用程式本身用於 Basic Access Authentication 的驗證資訊，具體來說是 client_id、client_secret。

OAth 2.0 根據授權許可的方式分為四種：

- 授權碼許可(Authorization Code Grant)
- 隱含許可(Implicit Grant)
- 資源擁有者密碼憑證許可(Resource Owner Password Credentials Grant)
- 客戶端憑證許可(Client Credentials Grant)

### 2.1. 授權碼許可(Authorization Code Grant)

第三方應用程式向授權伺服器請求授權碼，並將授權碼傳遞給資源伺服器以存取資源的授權流程，這是最常用的模式。

1. `網站使用者`在`授權伺服器`的登入站點申請`授權碼`。
2. `授權伺服器`將授權碼告知`第三方應用程式`
3. `第三方應用程式`使用`客戶端憑證`和收到的`授權碼` 向 `授權伺服器` 發起請求獲得 token。

### 2.2. 隱含許可(Implicit Grant)

因省略對第三方應用的授權碼直接以前端網址列取得 token ，故稱隱含式許可，但直接以前端網址參數的方式傳送 token 給網站使用者，是**非常不安全的作法**，一般 token 的有效期間設定為 session 期間有效 (關閉網頁即失效)。

1. `網站使用者`從`授權伺服器`登入。
2. `授權伺服器`直接在網址列帶入 access_token 轉跳第三方應用程式。

### 2.3. 資源擁有者密碼憑證許可(Resource Owner Password Credentials Grant)

讓第三方應用直接以網站使用者密碼取得 token，必須要是高度信任的第三方應用才能用此方法。

1. `第三方應用程式`向`使用者`請求其`帳戶密碼`(使用者憑證)。
2. `第三方應用程式`以`使用者帳戶密碼`向`授權伺服器`請求 token。

### 2.4. 客戶端憑證許可(Client Credentials Grant)

此種 token 針發放對象為第三方應用而非用戶，與用戶認証無關，由第三方應用傳送其自己的 user credentials 獲得 token。

1. `第三方應用程式`傳送其自己的`客戶端憑證`獲得 token。

<!-- 2. Security Considerations
   3.1. Authorization Server Security
   3.2. Resource Server Security
   3.3. Client Security 4. IANA Considerations

4.1. OAuth 2.0 URIs
4.2. OAuth 2.0 Header Parameters
4.3. OAuth 2.0 Response Payloads 5. References

5.1. Normative References
5.2. Informative References
Appendix A. Examples

A.1. Authorization Code Grant Example
A.2. Implicit Grant Example
A.3. Resource Owner Password Credentials Grant Example
A.4. Client Credentials Grant Example -->

# Token 種類

Token 短時效性，因此外流的 Token 會因為失效而無法作用。如果發放者有記載所發放的 Token 識別碼，可以進行撤銷的動作使驗證不通過。
分為 **access token** 和 **refresh token**。

# 傳送 Token

# 更新 Token

因為 Token 有其有效期限，每次到有效期限就要求使用者到登入點登入不是很實際的作法，因此後端可以 在 token 到期之前傳送 refresh token 來獲得更新的有效 token。

# Reference

- [阮一峰的网络日志 - 理解 OAuth 2.0](https://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html)
- [阮一峰的网络日志 - OAuth 2.0 的一个简单解释](http://www.ruanyifeng.com/blog/2019/04/oauth_design.html)
- [RFC 6749](http://www.rfcreader.com/#rfc6749)
