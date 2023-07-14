---
title: "[WebTech] OAuth 2.0 authorization"
date: 2020-11-14T21:41:00+08:00
lastmod: 2020-11-14T21:41:00+08:00
draft: true
tags: ["OAuth", "Authentication", "Token"]
categories: ["WebTech"]
author: "tigernaxo"

autoCollapseToc: true
#contentCopyright: '<a rel="license noopener" href="https://en.wikipedia.org/wiki/Wikipedia:Text_of_Creative_Commons_Attribution-ShareAlike_3.0_Unported_License" target="_blank">Creative Commons Attribution-ShareAlike License</a>'
---
OAuth 是一套授權框架，讓第三方應用程式(被授權方)不需取得原始帳號、密碼等敏感資訊，獲得有限的權限以存取資源，目前版本為 2.0。
運作方式為授權方發放令牌(token)，token 上記載相關權限資訊(scope)，進行需要權限的動作時再把 token 出示給系統讓系統進行驗證。

# Token 種類
Token 短時效性，因此外流的 Token 會因為失效而無法作用。如果發放者有記載所發放的 Token 識別碼，可以進行撤銷的動作使驗證不通過。
分為 **access token** 和 **refresh token**。
# 授權類型
- **授權碼（authorization-code）**  
  網站使用者在授權方的登入站點申請授權碼(authorization-code)後，將授權碼告至第3方應用程式，第3方應用在後端用自己的使用者資訊連(user credentials)連同使用者的授權碼對授權方發起請求並獲得 Token，這是最常用的模式。
- **隱含授予（implicit）**  
  網站使用者從授權方登入點登入後，授權方直接在設定轉跳的第3方應用網址列帶入 token，因為省略對第3方應用的授權碼直接以前端取得 Token 故稱隱含式授予，但這個方式將 token 直接以前端網址參數的方式傳送給網站使用者，是非常不安全的作法，一般 token 的有效期間設定為 session 期間有效，也就是說關閉網頁即失效。
- **密碼（password）**  
  讓第3方應用直接以網站使用者的密碼取得 token，必須要是高度信任的第3方應用才能用此方法。
- **客戶端憑證（client credentials）**
  此種令牌針發放對象為第3方應用而非用戶，所以與用戶認証無關，由第3方應用傳送其自己的 user credentials 獲得 token。

# 傳送 Token 

# 更新 Token
因為 Token 有其有效期限，每次到有效期限就要求使用者到登入點登入不是很實際的作法，因此後端可以 在 token 到期之前傳送 refresh token 來獲得更新的有效 token。

# Reference
- [阮一峰的网络日志 - 理解OAuth 2.0](https://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html)
- [阮一峰的网络日志 - OAuth 2.0 的一个简单解释](http://www.ruanyifeng.com/blog/2019/04/oauth_design.html)
- [RFC 6749](http://www.rfcreader.com/#rfc6749)