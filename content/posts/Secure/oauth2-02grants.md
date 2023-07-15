---
title: "[授權] OAuth 2.0 Authorization Framework 授權許可"
date: 2023-07-16T00:19:00+08:00
draft: false
hero:
menu:
  sidebar:
    name: "[授權] OAuth 2.0 授權許可"
    identifier: secure-oauth20-02grants
    parent: secure
    weight: 1010
---

## 授權許可 (Authorization Grant)

理解授權許可前需要先瞭解解幾個名詞：

- `授權碼 (Authorization Code)`：由授權伺服器產生，用於授權第三方應用程式存取資源的授權憑證。
- `存取權杖 (Access Token)`：由授權伺服器產生，用於允許第三方應用程式存取資源的授權憑證，時效通常較短。
- `刷新令牌 (Refresh Token)`：由授權伺服器產生，用於重新產生存取權杖的授權憑證，時效通常較長。
- `客戶端憑證`：第三方應用程式本身用於 Basic Access Authentication 的驗證資訊，具體來說是 client_id、client_secret。

OAth 2.0 根據授權許可的方式分為四種：

- 授權碼許可(Authorization Code Grant)
- 隱含許可(Implicit Grant)
- 資源擁有者密碼憑證許可(Resource Owner Password Credentials Grant)
- 客戶端憑證許可(Client Credentials Grant)

### 授權碼許可(Authorization Code Grant)

第三方應用程式向授權伺服器請求授權碼，並將授權碼傳遞給資源伺服器以存取資源的授權流程，這是最常用的模式。

1. `網站使用者`在`授權伺服器`的登入站點申請`授權碼`。
2. `授權伺服器`將授權碼告知`第三方應用程式`
3. `第三方應用程式`使用`客戶端憑證`和收到的`授權碼` 向 `授權伺服器` 發起請求獲得 token。

### 隱含許可(Implicit Grant)

因省略對第三方應用的授權碼直接以前端網址列取得 token ，故稱隱含式許可，但直接以前端網址參數的方式傳送 token 給網站使用者，是**非常不安全的作法**，一般 token 的有效期間設定為 session 期間有效 (關閉網頁即失效)。

1. `網站使用者`從`授權伺服器`登入。
2. `授權伺服器`直接在網址列帶入 access_token 轉跳第三方應用程式。

### 資源擁有者密碼憑證許可(Resource Owner Password Credentials Grant)

讓第三方應用直接以網站使用者密碼取得 token，必須要是高度信任的第三方應用才能用此方法。

1. `第三方應用程式`向`使用者`請求其`帳戶密碼`(使用者憑證)。
2. `第三方應用程式`以`使用者帳戶密碼`向`授權伺服器`請求 token。

### 客戶端憑證許可(Client Credentials Grant)

此種 token 針發放對象為第三方應用而非用戶，與用戶認証無關，由第三方應用傳送其自己的 user credentials 獲得 token。

1. `第三方應用程式`傳送其自己的`客戶端憑證`獲得 token。

## Reference

- [RFC 6749](http://www.rfcreader.com/#rfc6749)
