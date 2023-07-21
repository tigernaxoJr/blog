---
title: "[憑證] Token"
date: 2023-07-15T00:36:00+08:00
draft: true
hero:
menu:
  sidebar:
    name: "[憑證] 前端 Token 保護"
    identifier: secure-token
    parent: secure
    weight: 1000
---

Token..
## Token 種類

 - Opaque Token：不透明的 Token，對使用者來說本身只是無意義的字串，無法直接檢視裡面的內容，需要透過驗證伺服器解釋。
 - Not Opaque Token：token 內含有意義的資訊，使用者可以直接檢視。
 - JWT(Json Web Token)：是一種 Not Opaque Token，Header、Paload、Signature組成。
 - ID Token：是一種 JWT，
透明的 Token，本身就帶有資訊 ex: ID Token、 JWT

### JWT(Json Web Token)
JWT 結構為三個分隔部分：
 - Header（標頭）
 - Payload（有效載荷）
 - Signature（簽名）。  

標頭(Header)和有效載荷(Payload)是 JSON 格式以 Base64 編碼組成，可以包含有關使用者、資源或其他資訊。簽名(Signature)則用於驗證，以確保Token在傳遞過程未被篡改。

## 儲存位址

必須要 ajax 可存取的位址，可供選擇如下：

| 位置           | 優點               | 缺點                     |
| -------------- | ------------------ | ------------------------ |
| localStorage   | 網頁關閉還存在     | XSS 攻擊                 |
| sessionStorage | -                  | XSS 攻擊、網頁關閉就消失 |
| cookie         | 必須取消 HTTP-only | CSRF 風險、cookie 容量小 |
| memory         | XSS 攻擊保護       | 網頁關閉就消失           |

## 安全性

## 保護手段

Token encryption: Encrypt the tokens before storing them in localStorage and decrypt them when needed. This adds an extra layer of protection against unauthorized access.

Token rotation: Regularly rotate the access and refresh tokens to reduce their lifespan and potential exposure to attacks.

Limited token scope: Reduce the scope and privileges associated with the tokens to minimize potential harm if they are compromised.

Token revocation: Implement mechanisms to revoke and invalidate tokens if they are suspected or known to be compromised.
