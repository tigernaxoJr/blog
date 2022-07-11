---
title: "[Web] RESTful 敏感性 GET 參數"
date: 2022-07-11T11:35:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[Web] 敏感性 GET 參數"
    identifier: web-security-get
    parent: web
    weight: 1000
---
## 網址列參數洩漏風險
目前網頁後端資源存取大多以 RESTful Api 開發，
REST 標準下 API 的設計需符合冪等性(idempotent)，
SSL 連線連接 TCP 層與 HTTP 層，因此透過 HTTPS 傳輸的網頁，網址進入 TCP 層之後是被加密的，
即使封包被截取也只能看見要傳送的目標主機
那麼敏感性資料可以透過 GET 參數傳送嗎？

如果將機敏性資料夾帶於網址列當中會有洩漏的安全性風險，諸如：
- 被 Shoulder surfers 竊取。(你的螢幕被偷看)
- 隨著頁面列印被印出。
- 使用者將連結加入書籤。
- 儲存在瀏覽器瀏覽歷史紀錄。
- 被記錄在 Web Server 的 Log，而 Log 本身可能不安全。

## 隱藏 RESTful GET 參數
因此避免這些資料外洩的可能，根本的做法就是讓機敏性資料從網址列消失，最好的做法是依據 OWASP 的建議把 參數夾帶在 Header 裡面，其他手段整理：
- 將機敏性資料加密，但加密也**會破壞 API RESTful 特性**，在後端需要先解密無法直接對應回物件。
- 以 POST 的一部份傳輸(透過 HTTPS)，但**會直接破壞 API 的 RESTful 特性**。
- 根據 [OWASP REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html)，應該把敏感性參數夾帶在 GET 請求的 HTTP Header 裡面透過 HTTPS 傳輸。

P.S. OWASP 的 Cheat Sheet 可看出並非所有資料都要不能出現在網址列，只有機敏性資料才需要考慮從網址列移除。`

## Reference
- [stackoverflow - Are HTTPS URLs encrypted?](https://stackoverflow.com/questions/499591/are-https-urls-encrypted/499594#499594)
- [stackoverflow - Should sensitive data ever be passed in the query string?](https://security.stackexchange.com/questions/29598/should-sensitive-data-ever-be-passed-in-the-query-string)
- [OWASP - REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html)
