---
title: "[Docker] 在 Ubuntu 安裝 Docker"
date: 2022-11-15T08:46:00+08:00
hero: 
draft: false
menu:
  sidebar:
    name: "[Docker] 安裝"
    identifier: container-docker-install
    parent: container
    weight: 2000
---
從 [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) 總結出腳本，直接執行就好：
```bash
#!/bin/bash
# Uninstall old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Set up the repository
# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# 把當前使用者加到 docker 群組
sudo usermod -aG docker ${USER}

# Verify that the Docker Engine installation is successful by running the hello-world image
sudo docker run hello-world
```
## Reference
 - [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)