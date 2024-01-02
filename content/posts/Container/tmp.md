---
title: "[容器] Open Container Initiative (OCI)"
date: 2022-04-25T06:26:00+08:00
hero: 
draft: true
menu:
  sidebar:
    name: "[Basic] Open Container Initiative (OCI)"
    identifier: container-base-oci
    parent: container
    weight: 2000
---

OCI（Open Container Initiative）是一個開放的行業標準組織，旨在定義容器格式和運行時的規範，以確保容器在不同的容器執行環境中能夠保持一致性和互通性。

OCI 的主要組成部分包括容器映像（Image）和容器執行時（Runtime）的規範。容器映像規範定義了容器的打包格式，確保在不同的運行環境中能夠一致地部署。容器執行時規範則定義了容器的運行時行為，確保容器在各種容器執行環境中都能夠正確運行。

https://github.com/opencontainers/runtime-spec/blob/main/config-linux.md


CRI
https://ithelp.ithome.com.tw/articles/10218127

CNI
在 Kubernetes（k8s）中，有一些與容器和容器環境相關的重要術語，包括OCI、CRI、CNI。以下是對這些術語的解釋：

- OCI（Open Container Initiative）:
功能： OCI 是一個開放的行業標準組織，致力於定義容器格式和運行時的規範。OCI 的主要目標是確保容器在不同的容器執行環境中能夠保持一致性和互通性。OCI 的規範包括容器映像（Image）和容器運行時（Runtime）的標準，確保容器能夠在各種 OCI 兼容的容器執行時中運行。

- CRI（Container Runtime Interface）:
功能： CRI 是 Kubernetes 中的一個介面，用於定義容器運行時（Container Runtime）和 Kubernetes 的通信標準。它允許 Kubernetes 與不同的容器運行時進行交互，使得 Kubernetes 不依賴於特定的容器運行時實現。Kubernetes 通過 CRI 與容器運行時進行通信，包括容器的創建、啟動、停止等操作。

- CNI（Container Networking Interface）:
功能： CNI 是 Kubernetes 中用於定義容器網路的標準介面。它定義了容器如何連接到網路，以及網路如何在不同的容器執行時中實現。CNI 允許 Kubernetes 使用不同的網路插件，以滿足各種網路需求。簡而言之，CNI 提供了一種標準的方法來設定容器的網路，並支援不同的網路實現。

https://kubernetes.io/

https://minikube.sigs.k8s.io/docs/