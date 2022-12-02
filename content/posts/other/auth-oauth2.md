---
title: "[授權] OAuth2.0"
date: 2022-12-02T12:43:00+08:00
draft: false
hero:
menu:
  sidebar:
    name: "[授權] OAuth2.0"
    identifier: other-auth-oauth2
    parent: other
    weight: 1000
---
OAuth 是一個開發標準(Open Standard)，用來處理有關「授權」（Authorization）相關的問題
允許授權當下的APP取得使用者在平台的相關資訊
OAuth2 有很多變化

腳色：
 - Resource Owner，也就是使用者。
 - Client，要向使用者取得權限的應用程式，有自己的 Client ID、 Client Secret。
 - Authorization Server，負責驗證使用者身分、發 Access Token 給應用程式
 - Resource Server，存放資源的伺服器，認 Token 給使用者存取資源

用詞
 - Authorization Grant 同意應用程式取得資源
 - Redirect URI 驗證伺服器驗證、授權完畢後，返回應用程式的路徑
 - Scope 授權範圍

## OAuth2.0 四種授權類型流程(Grant Types)：
### Authorization Code
最常見，步驟：
1. 應用程式(Client) 將使用者導向 Authorization Server，提供 Redirect URL, scope, 應用程式的 client id...
2. Authorization Server 驗證使用者身分，通過之後發給 Authorization Grant，將網址列帶上 Authorization Grant 後將使用者導回 Redirect URI 回到應用程式(Client)。
3. 應用程式(Client)拿 Authorization Grant 和 Authorization Server 換取 Access Token，Authorization Server 會透過應用程式(Client)專屬的 Client ID、 Client Secret 驗證應用程式身分。
4. 應用程式(Client)帶著 Access Token 向 Resource Server 存取資源

### Implicit
適合在 Client-side 運行的應用程式適合使用，例如 SPA(Single Page Application)
跳過交換 Access Token 的過程，由 Authorization Server 直接給予 Access Token
比較不安全

### Resource Owner Password Credentials
使用者透過應用程式(Client)，提供帳號密碼給 Authorization Server拿到 Access Token

### Client Credentials
M2M (machine-to-machine)
通常是應用程式向 Authorization Server 請求取得獲取自己相關資源的 Access Token，而不是為了獲取使用者的資源。
不需要驗證使用者身分，單純應用程式向 Authorization Server 驗證自己的資訊。

## Reference
- [[筆記] 認識 OAuth 2.0：一次了解各角色、各類型流程的差異](https://medium.com/%E9%BA%A5%E5%85%8B%E7%9A%84%E5%8D%8A%E8%B7%AF%E5%87%BA%E5%AE%B6%E7%AD%86%E8%A8%98/%E7%AD%86%E8%A8%98-%E8%AA%8D%E8%AD%98-oauth-2-0-%E4%B8%80%E6%AC%A1%E4%BA%86%E8%A7%A3%E5%90%84%E8%A7%92%E8%89%B2-%E5%90%84%E9%A1%9E%E5%9E%8B%E6%B5%81%E7%A8%8B%E7%9A%84%E5%B7%AE%E7%95%B0-c42da83a6015)
- [](https://ithelp.ithome.com.tw/articles/10225956)