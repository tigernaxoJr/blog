---
title: "[System] 多層式架構(Multitier Architecture)"
date: 2021-05-17T23:20:00+08:00
lastmod: 2021-05-17T23:20:00+08:00
draft: false
tags: ["N-Tier", "Multitier Architecture", "N-Tier Architecture"]
categories: ["System"]
author: "tigernaxo"

autoCollapseToc: true
---
多層式架構 Multitier Architecture 或稱 N-Tier Architecture，
是 Client–server architecture 的一種，
多層架構的層可以是 layer 或 tier，這兩者之間主要的差別在於 layer 指程式邏輯在應用程式的位置；
而 tier 指 layer 在系統上實際部屬執行的位址，屬於物理層級的指涉。
這一篇的層指的是 tier。


# N-tier model
N-tier model，層與層之間的邊界有 N-1 個，而程式跨邊界會造成巨大的效能損失，
一說為光是跨越同一台機器上不同進程(process)邊界存取資源損失就大約1000倍，
如果透過網路進行遠端呼叫勢必損失更多，
因此每跨越一個邊界進行資源存取效能就會以幾何級數損失。
且增加邊界在軟體設計上會增加複雜度，簡單的應用程式使用多層式架構很容易造成過度設計(over design)，
因此如何適當添加層級(tier)也是一門學問，添加層級時必需考量如何在應用程式所部屬的環境獲取最大的成本效益。
軟體是否採用多層式架構必須以多層式架構的優缺點進行取捨(尤其是可擴展性與效能之間)。
- 提高可擴展性(scalability)。
- 提高效能(performance)。
- 提高容錯率(fault tolerance)。
- 提高安全性(security)。

## 1-tier model
所有的 layer 都在同一機器、同一記憶體空間內運行，因此不需考慮網路造成的性能損失。
## 2-tier model
layer 分配至兩個不同的記憶體空間運行，記憶體空間可能位於相同或兩台不同的機器上(通常是不同機器)，典型的例子是分配到 client、server 上運行。
## 3-tier model
多層式架構當中最常使用的就是三層架構(three-tier architecture)。
三層架構與Web應用程式來說明如下：
- 表現層(Presentation)：又稱為 UI 層，以Web來說就是呈現出來的前端網頁。
- 應用程式層(Application)：以 Web 來說相當於伺服器上執行的應用程式。
- 資料層(Data)：這一層包含資料儲存、呈現機制，以 Web 來說通常指 Database。

# Reference
- [wikipedia - Multitier architecture](https://en.wikipedia.org/wiki/Multitier_architecture)
- [Rockford Lhotka - Should all apps be n-tier?](http://www.lhotka.net/weblog/ShouldAllAppsBeNtier.aspx)
- [N Tier(Multi-Tier), 3-Tier, 2-Tier Architecture with EXAMPLE](https://www.guru99.com/n-tier-architecture-system-concepts-tips.html)