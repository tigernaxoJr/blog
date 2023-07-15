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
