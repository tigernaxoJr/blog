---
title: "[Web] WebSub"
date: 2023-07-07T08:11:00+08:00
draft: true
hero: 
menu:
  sidebar:
    name: "[Web] WebSub"
    identifier: web-websub
    parent: web
    weight: 1000
---
WebSub 是一個用於`發布者（Publisher）`和`訂閱者（Subscriber）`之間，`各種網頁內容`通信的通用機制。  
`訂閱者請求`通過中樞（hubs）進行中繼，`中樞會驗證和驗證`請求。
當有新的內容或內容更新時，中樞會`透過 HTTP Webhook 分發給訂閱者`。  
WebSub 以前被稱為 PubSubHubbub。  
這裡描述 content-type 是 json 的情況，xml 需要不同機制處理。
步驟：
 - `訂閱者向發布者`請求資源，並在發布者回傳的`HTTP標頭`當中發現 hub。
 - `訂閱者向hub`送出POST請求訂閱。
 - `hub`透過GET驗證和驗證訂閱請求。
 - `發布者`告訴 hub 內容更新。
 - `hub`送出POST告訴訂閱者內容更新。
##
WebSub 名詞解釋  
 - `Topic`：簡單說就是 Publisher 的 resource URL。
 - `Publisher`：topic 擁有者，告知 hub topic 已經改變，本身不會知道被誰訂閱。
 - `Subcriber`：一個需要被即時通知 topic 改變的實體(entity)，必須要有可呼叫的 Callback URL （Http WebHook）用來接收 topic 更新通知，流程中使用 Callback URL 作為 id。
 - `Hub`：
 - `Subscription`： id 是一個 tuple (Topic, Subscriber Callback URL)，根據 hub 的政策可能類似 DHCP 需要定期更新。
 - `Event`：Publisher 上發生的事件，可能同時會更新很多 topic。
 - `Content Distribution Notification (Content Distribution Request)`：依據 topic 種類(content type)不同，可以是描述 topic 內容改變的 payload 或完整的 topic 內容，topic 內容的差異被 hub 計算過後推送到訂閱者。
## Discovery Mechanisms
 - header 中`至少`要有一個 rel=hub 的 link 描述 `hub 位址`
 - header 中`只能`有一個 rel=self 的 link 描述 `topic`
## Content Negotiation
要在 initial discovery request 裡面聲明 Content-type
##
WebSub 訂閱的原理  
![](https://www.w3.org/TR/websub/websub-overview.svg)  

腳色：
 - Subscriber：訂閱方，提供 webhook 接收 event 和 event payload
 - Publisher：發布方，提供資源 URL，呼叫 Hub 發布事件和 event payload
 - Hub：接受/取消訂閱、發布事件
## Reference 
 - [w3-websub](https://www.w3.org/TR/websub/)