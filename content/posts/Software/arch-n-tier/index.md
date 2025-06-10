---
title: "[架構] 多層式架構(Multitier Architecture)"
date: 2021-05-17T23:20:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[架構] 多層(tier)架構"
    identifier: software-arch-n-tier
    parent: software
    weight: 1000
---
# 多層式架構 (Multitier Architecture) 🏗️
多層式架構（Multitier Architecture），也稱為 N-Tier Architecture，是**主從式架構（Client-Server Architecture）**的一種實現方式。在討論這個架構時，我們常會聽到「層」（layer）和「階」（tier）這兩個詞。

這兩者主要的差別在於：

層 (Layer)：指應用程式中邏輯功能的劃分，例如表現層、業務邏輯層、資料存取層。它關注的是程式碼的組織與職責分離。
階 (Tier)：指這些邏輯層在物理上的部署位置。一個「階」可以是一台獨立的伺服器、一個虛擬機或一個容器。它關注的是系統的實際部署環境。
簡單來說，Layer 是邏輯上的劃分，而 Tier 是物理上的部署。本篇文章主要討論的是物理部署層面的「階 (Tier)」。


## N-Tier 模型：優點與權衡 ⚖️
在 N-Tier 模型中，層與層之間的邊界有 N-1 個。程式碼每次跨越一個邊界，都會帶來顯著的效能耗損。據估計，僅僅是跨越同一台機器上不同進程（process）的邊界，效能損失就可能高達 1000 倍。如果這個邊界是透過網路進行的遠端呼叫，效能損失將更為巨大。

因此，每增加一個 Tier，系統的複雜度就會提升，效能也可能呈幾何級數下降。對於簡單的應用程式來說，過多的層級劃分容易造成過度設計（Over-design）。

在決定是否採用多層式架構時，必須在以下幾個優點與效能之間做出權衡：

- **提高可擴展性 (Scalability)**：可以針對特定的 Tier（例如應用程式伺服器）進行獨立擴展，以應對不斷增長的負載。
- **提高容錯率 (Fault Tolerance)**：單一 Tier 的故障不會輕易導致整個系統癱瘓。例如，如果一台 Web 伺服器當機，負載平衡器可以將流量導向其他正常的伺服器。
- **提高安全性 (Security)**：可以在不同 Tier 之間設置防火牆或不同的安全規則。例如，資料庫伺服器可以被嚴格保護在內部網路中，只允許應用程式層存取。
- **提高效能 (Performance)**：雖然跨層通訊會有效能損耗，但透過將不同任務分配給專門的伺服器（例如，資料庫伺服器專門處理資料查詢），可以優化整體系統的處理效率和響應能力。

## 常見的 Tier 模型
### 單層式架構 (1-Tier Model)
在單層模型中，所有的邏輯層（表現層、應用層、資料層）都運行在同一台機器、同一個進程中。這種架構下，由於沒有跨越進程或網路邊界，因此沒有額外的通訊效能損失。早期的個人電腦應用程式多屬於此類。

### 雙層式架構 (2-Tier Model)
雙層模型將邏輯層分配到兩個不同的記憶體空間運行。這兩個空間可能在同一台機器上，但更常見的是部署在兩台不同的機器上，也就是典型的主從式架構（Client-Server）。

- **Client (客戶端)**：負責表現層。
- **Server (伺服器)**：負責應用邏輯與資料存儲。
### 三層式架構 (3-Tier Model) 
三層式架構是目前最廣泛應用的模型，尤其是在 Web 應用程式中。它將系統劃分為三個獨立的、可單獨部署和管理的 Tier。

以一個典型的 Web 應用程式為例：

1. 表現層 (Presentation Tier)   
   職責：處理使用者介面（UI）與互動。  
   實例：使用者瀏覽器中呈現的前端網頁，由 HTML, CSS, JavaScript 構成。這是使用者直接接觸和操作的部分。
2. 應用程式層 (Application Tier) ️  
    職責：實現核心的業務邏輯、處理和運算。也稱為「邏輯層」或「中介層」。  
    實例：部署在後端伺服器上的應用程式（如 Java, Python, Node.js）。它接收來自表現層的請求，執行相應的業務處理，並與資料層溝通。
3. 資料層 (Data Tier)  
    職責：負責資料的儲存、管理與存取。  
    實例：資料庫管理系統（DBMS），如 MySQL, PostgreSQL, MongoDB。這一層確保資料的一致性、安全性與持久性。

# Reference
- [wikipedia - Multitier architecture](https://en.wikipedia.org/wiki/Multitier_architecture)
- [Rockford Lhotka - Should all apps be n-tier?](http://www.lhotka.net/weblog/ShouldAllAppsBeNtier.aspx)
- [N Tier(Multi-Tier), 3-Tier, 2-Tier Architecture with EXAMPLE](https://www.guru99.com/n-tier-architecture-system-concepts-tips.html)