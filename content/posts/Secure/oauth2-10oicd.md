---
title: "[授權] OpenID Connect (OIDC) 基於 OAuth 2.0 協議的身份驗證和授權層"
date: 2023-07-16T00:19:00+08:00
draft: true
hero:
menu:
  sidebar:
    name: "[授權] OAuth 2.0 - OIDC"
    identifier: secure-oicd-00
    parent: secure
    weight: 1030
---

OAuth 2.0 只定義如何授權，OIDC 要處理認證

- `Relying Party`：相當於 OAuth 2.0 當中的 `client`。
- `JWS`：JSON Web Signature (RFC 7515)
- `JWT`：JWT（JSON Web Token）是基於 JWS（JSON Web Signature）標準的 token 格式。
- `ID Token`：採用 JWS ，資源伺服器能透過數位簽章確保使用者的身分正確性。

OpenID Connect（OIDC）是基於 OAuth 2.0 協議的身份驗證和授權層，
定義用於`身份驗證`和`使用者資訊交換`的規範。OIDC 的標準文件是 RFC 6749 和 RFC 6750。

OpenID Connect 的具體規範是通過一系列的 OIDC 規範來定義的，其中包括：

RFC 6749: The OAuth 2.0 Authorization Framework
RFC 6750: The OAuth 2.0 Authorization Framework: Bearer Token Usage
OpenID Connect Core: The OpenID Connect Core 1.0 specification
OpenID Connect Discovery: OpenID Connect Discovery 1.0
OpenID Connect Dynamic Client Registration: OpenID Connect Dynamic Client Registration 1.0
OpenID Connect Session Management: OpenID Connect Session Management 1.0
等等。
這些規範一起定義了 OpenID Connect 協議的核心功能和特性，使其成為現代身份驗證和授權的常用標準之一。

## Reference

RFC 7515
