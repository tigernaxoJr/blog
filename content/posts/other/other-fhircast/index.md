---
title: "[Other] FHIRcast"
date: 2023-07-07T08:11:00+08:00
draft: true
hero: 
menu:
  sidebar:
    name: "[Other] FHIRcast"
    identifier: other-FHIRcast
    parent: other 
    weight: 1000
---
### topic:
 - 就是要同步的 session id 
 - 同一個 topic 下有很多 event  

### subscriber:
 - 在 subscription 建立前 subscriber 必須要知道
   1. hub.topic：要訂閱的主題
   2. hub.url：跟哪裡要訂閱
 - 可自己決定要訂閱的特定 event
 - 無法針對 topic 下的 event 退訂，一定是退訂整個 topic

## SMART 
"SMART on FHIR EHR launch" 和 "SMART on FHIR standalone launch" 是 SMART（Substitutable Medical Applications, Reusable Technologies）在 FHIR（Fast Healthcare Interoperability Resources）框架下兩種不同的啟動方式。這兩種啟動方式在使用 SMART 應用程序和與電子健康記錄系統（EHR）或獨立部署環境的交互方面存在一些差異。

SMART on FHIR EHR launch:

EHR launch 是指 SMART 應用程序直接嵌入到電子健康記錄系統中，並從 EHR 中獲取所需的上下文信息。
使用 EHR launch，SMART 應用程序可以藉助於與 EHR 系統的整合，進行單一簽入（Single Sign-On）和訪問患者的醫療數據等功能。
EHR launch 通常需要在 EHR 系統中進行配置和授權，以便 SMART 應用程序可以與 EHR 系統進行交互操作。
SMART on FHIR standalone launch:

standalone launch 是指 SMART 應用程序在獨立部署環境中運行，而不是直接嵌入到 EHR 系統中。
使用 standalone launch，SMART 應用程序可以運行在獨立的應用程序容器中，與不同的健康信息系統進行集成和交互。
standalone launch 通常需要進行授權並與目標系統進行驗證，以確保 SMART 應用程序在安全且受控的環境中運行。
總結來說，SMART on FHIR EHR launch 和 SMART on FHIR standalone launch 是兩種使用 SMART on FHIR 框架的不同方式。EHR launch 將 SMART 應用程序直接嵌入到 EHR 系統中，從中獲取上下文信息和醫療數據，而 standalone launch 則在獨立部署環境中運行，通過與不同的健康信息系統進行集成來實現功能。具體使用哪種啟動方式取決於 SMART 應用程序的需求和部署環境的特點。