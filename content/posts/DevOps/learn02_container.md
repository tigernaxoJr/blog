---
title: "[DevOps] 初學開發運維-02 容器"
date: 2021-10-15T11:11:00+08:00
lastmod: 2021-10-15T11:11:00+08:00
draft: true
tags: ["docker", "k8s", "CI/CD"]
categories: ["DevOps"]
author: "tigernaxo"

autoCollapseToc: false
---
DevOps 的關鍵就是容器。

# 容器(container)
目前最主流的容器軟體是 Docker，容器管理平台是 K8S(Kubernetes)

## 容器軟體
容器軟體用來運行容器。 
部署容器啟要的資源由容器需要的 CPU、RAM、啟動數量決定，

## 容器管理平台
容器管理平台將每一個可運行容器的 OS(aka Docker 主機) 視為節點(Node)，每個節點的硬體資源可能有所不同，
容器管理平台，管理、調度多個節點的可用資源，讓容器部屬在節點上，
並**掌控**、**維持**容器的運行狀態。
其中最重要的是維持容器的運行狀態，又稱為維持服務級別目標(SLO; Service Level Objective)。
透過這一的機制，使用者只需要告訴容器管理平台容器要運行的容器，不需理會實際各節點資源使用情形、要部屬在哪個節點等等細節...

講白話就是，K8S 根據資源把應用程式適當部屬在不同 OS 內的 Docker，並管理應用程式的運營狀態，在應用程式發生錯誤時進行重啟等等措施。
# 硬體
## 硬體資源擴充與服務執行環境隔離

傳統運維的手法？ shell?
#  CICD
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
- [wiki - Service-level objective](https://en.wikipedia.org/wiki/Service-level_objective)
- [2017 iT 邦幫忙鐵人賽 - Container 容器三十問](https://ithelp.ithome.com.tw/users/20060041/ironman/1164)