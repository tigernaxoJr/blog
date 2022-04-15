---
title: "[DevOps] 初學開發運維03-Docker 安裝"
date: 2021-09-22T11:11:00+08:00
lastmod: 2021-09-22T11:11:00+08:00
draft: true
tags: ["docker"]
categories: ["DevOps"]
author: "tigernaxo"

autoCollapseToc: false
---
Docker 是 K8S 的基礎，K8S之前需要先瞭解 Docker
OS: Ubuntu 20.04 Server

```bash
# 卸載舊的 docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc

# 安裝必要的套件
# apt-transport-https 讓套件管理程式可以透過 https 協定使用 repo
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 添加 Docker 官方 GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 設置 stable 版本的 docker repository
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
# 安裝 Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# 下載測試 image 並執行，預期會得到輸出然後 container 就會結束
sudo docker run hello-world
```

# Reference
- [Docker.com - Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)