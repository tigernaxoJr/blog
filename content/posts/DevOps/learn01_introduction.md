---
title: "[DevOps] 初學開發運維-01 DevOps 簡介"
date: 2021-10-15T11:11:00+08:00
lastmod: 2021-10-15T11:11:00+08:00
draft: true
tags: ["docker", "k8s", "CI/CD"]
categories: ["DevOps"]
author: "tigernaxo"

autoCollapseToc: false
---
# DevOps
DevOps，開發運維，也就是自動化**開發(Development)**、**運維(Operations)**、**測試(Quality Assurance)**。

傳統上開發與運維人員各自作業，
開發人員扮演改變軟體(不論是功能、架構)腳色；
但運維人員最害怕的就是軟體部屬造成的系統不穩定。
而無論在組織內部開發與運維人員是否由同一人擔任，
每次程式開發上線大同小異的作業流程(測試、部屬...)都需要各自分配人力資源：
 - 開發：由程式設計師開發程式。
 - 測試：開發到一個階段由開發者或測試人員測試、撰寫測試報告。
 - 部屬：寫腳本建立程式環境、部屬程式。
 - 運維：軟體環境調校和軟體維護作業。

DevOps 結合開發與運維，以自動化串聯開發(交付軟體改變架構/功能)和運維(維持穩定性)中間的流程(包含測試、部屬)，
達成自動化測試、自動化部屬，
大幅縮短開發到交付部屬上線的時間，從而大幅減少投注的人力資源成本，也使產品可更精準快速回應市場需求，
讓整個過程變得更快速可靠。

#  CICD
將版本控制、自動化測試整合到自動化開發-自動化部屬中間的流程，
使得程式碼提交之後可以在雲端環境自動建置應用程式、執行單元測試，
這個流程稱為做持續交付(CI; Coutinuous Integration)/持續部屬(CD; Coutinuous Deployment)。
統一在雲端建置的好處是可以避免開發人員的環境可以執行，線上卻不行的情況 。

上程式的流程自動化

導入現代化 DevOps 帶來什麼好處
方便
安全問題：工程師將編譯的檔案直接放上伺服器，但是程式碼沒有進入版控，會造成混亂。

# Reference
- [第 11 屆 iThome 鐵人賽-就是「懶」才更需要重視DevOps](https://ithelp.ithome.com.tw/users/20120491/ironman/2538)
- [何謂微服務 - 台灣|IBM](https://www.ibm.com/tw-zh/cloud/learn/microservices)
- [medium - 從單體到微服務](https://yunchenli.medium.com/%E5%BE%9E%E5%96%AE%E9%AB%94%E5%88%B0%E5%BE%AE%E6%9C%8D%E5%8B%99-12e206805089)
- [Microservices vs Monolithic Architecture](https://www.mulesoft.com/resources/api/microservices-vs-monolithic)
- [wiki - Multitier architecture](https://en.wikipedia.org/wiki/Multitier_architecture#Three-tier_architecture)