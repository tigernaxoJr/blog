---
title: "[DevOps] 建構 .NET Core 的 Gitlab CI/CD Pipeline"
date: 2021-10-27T14:20:00+08:00
lastmod: 2021-10-27T14:20:00+08:00
draft: true
tags: ["docker", ]
categories: ["DevOps"]
author: "tigernaxo"

autoCollapseToc: true
---
這篇文章紀錄以 Gitlab CI/CD 建構一條 .NET Core 專案 DevOps Pipeline 的過程，
所有動作都採取容器化的方案，因此需要在 Server 上先安裝容器軟體，
機器實體或虛擬機器不拘，這裡是使用 virtualbox 開一台 ubuntu 的虛擬機作為伺服器，
使用的環境為 Linux(Ubuntu 20.04 LTS)，因此需要熟悉一些 Linux 指令，
如果是從 Window 體系來的 Linux 都不熟，
那麼這篇文章的目標原本是讓你照打就能輕易建構一條 Pipeline，試試看我是否有成功吧！

# 設定虛擬機
 > 如果不需要自己用 virtualbox 建機器做測試的可以跳過這一節。  

首先你必須要安裝 virtualbox，然後安裝一部 Ubuntu 20.04 VM。  
這部 VM 需要以下兩項網路，其中 Host-Only 網路需要額外設定：
 1. NAT 網路：拿來上網(要安裝套件)，virtualbox 在建立新的 VM 時已默認設置。
 2. Host-Only 網路：讓 Host 得以透過 IP 和 VM 進行通訊，需**關閉虛擬機器**手動添加 Host-Only Adaptor 網卡(下圖)。

![添加網路介面卡](./add_host_only_adaptor.png)

外部添加完網路卡之後，打開 VM 進入 Ubuntu 新建網卡，
修改VM上的檔案 `/etc/netplan/00-installer-config.yaml`，
可以看到接在預設 NAT 網路上的網卡名稱叫做 `enp0s3`，
目前要新設定一張 `enp0s8` 給 host-only 網路使用並指定靜態 IP，
檔案最後長這樣：
```yaml
network:
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      addresses: [192.168.56.100/24]  # 靜態IP、遮罩
      routes:
      - to: 192.168.56.1/24
        via: 192.168.56.1
        metric: 100
      #gateway4: 192.168.56.1  # IPV4 Getway ip
      #nameservers:
      #addresses: [8.8.8.8,8.8.4.4] # DNS server ip，若有多個就以逗號分隔
      dhcp4: no # 關閉 dhcp 自動取得 IP
      dhcp6: no # 關閉 dhcp 自動取得 IP
  version: 2

```
測試設定
```bash
sudo netplan try
  Warning: Stopping systemd-networkd.service, but it can still be activated by:
  systemd-networkd.socket
  Do you want to keep these settings?
  Press ENTER before the timeout to accept the new configuration
  Changes will revert in 120 seconds
  Configuration accepted.
```
應用網卡設定
```bash
sudo netplan apply
```

如此一來，在 host 就可以用 `192.168.56.100` 連接虛擬機器
同理，在虛擬機器可以透過 `192.168.56.1` 連接 host，


下一步是設置 Host 對應，把
在伺服器沒有 Domain 的情況(例如用虛擬機器)需要透過更改 Client 端的 host 設定檔讓 client 不必透過 DNS 就能將自定義的 Domain 對應到伺服器的 IP：
假設要對應的 domain 是 example.com

修改檔案`C:\WINDOWS\system32\drivers\etc\hosts`(Windows)或`/etc/hosts`(Linux)，新增兩行：
```
192.168.56.100 example.com
192.168.56.100 gitlab.example.com
```
在 windows 上測試 example.com 是否接通到虛擬機(192.168.56.100)
```
> tracert example.com
在上限 30 個躍點上
追蹤 example.com [192.168.56.100] 的路由:
1    <1 ms    <1 ms    <1 ms  example.com [192.168.56.100]

追蹤完成。
```
在 Linux 上測試 example.com 是否接通到虛擬機(192.168.56.100)
```
$ ping example.com
PING example.com (192.168.56.100) 56(84) bytes of data.
64 bytes from example.com (192.168.56.100): icmp_seq=1 ttl=128 time=0.832 ms
64 bytes from example.com (192.168.56.100): icmp_seq=2 ttl=128 time=0.806 ms
64 bytes from example.com (192.168.56.100): icmp_seq=3 ttl=128 time=0.497 ms
64 bytes from example.com (192.168.56.100): icmp_seq=4 ttl=128 time=0.449 ms
```

# 安裝 Docker
指令
```bash
# 先解除安裝舊版本
sudo apt-get remove -y docker docker-engine docker.io containerd runc

# 安裝 docker 需要的套件
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 添加 Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 把 docker 的 stable 版本加到套件來源清單中
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
# 安裝 Docker Engine、Docker Compose
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

# 用 test image 測試 docker 安裝是否成功
sudo docker run hello-world
```
由於 docker 只有 root 或 docker 群組能夠使用(/var/run/docker.sock 的權限)，故需要把當前使用者加到 docker 群組，然後**重新登入**才會生效。
```bash
sudo usermod -aG docker ${USER}
```

# 安裝 Gitlab
直接輸入整理好的指令：
```bash
# 設置環境變數，讓 gitlab 掛載到 host 檔案系統的 `/srv/gitlab`
export GITLAB_HOME=/srv/gitlab

# 新增 docker-compose 檔案 `docker-compose.yml`
cat <<EOF | tee docker-compose.yaml
web:
  image: 'gitlab/gitlab-ce'
  restart: always
  hostname: 'gitlab.example.com'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'https://gitlab.example.com'
      # Add any other gitlab.rb configuration here, each on its own line
  ports:
    - '80:80'
    - '443:443'
    - '9022:22'
  volumes:
    - '$GITLAB_HOME/config:/etc/gitlab'
    - '$GITLAB_HOME/logs:/var/log/gitlab'
    - '$GITLAB_HOME/data:/var/opt/gitlab'
EOF

# 啟動容器
docker-compose up -d
```
接著等很長一陣子待 gitlab 容器啟動之後，
從 host 進入 https://example.com，應該就能看見 gitlab 的畫面了。
可以從這個檔案取得起始密碼：
```bash
cat /srv/gitlab/config/initial_root_password
```
> 如果要手動設置密碼可以參考這個方式：
>  ```bash
>  # 用下面指令找到 gitlab 的 CONTAINER ID，假設是 1ef38ce507e7 
>  docker ps
>  # 進入容器的 bash 更改密碼為 root1234
>  docker exec -it 1ef38ce507e7 /bin/bash
>  gitlab-rails console
>  u = User.find_by_username('1')
>  u.password = 'root1234'
>  u.password_confirmation = 'root1234'
>  u.save!
>  ```

```
version: "3.3"
services:
  nginx:
    image: 'nginx'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/srv/nginx/conf.d:/etc/nginx/conf.d'
      - '/srv/nginx/log:/var/log/nginx'
      - '/srv/nginx/html:/usr/share/nginx/html'
#    restart: always
#  gitlab:
#    image: 'gitlab/gitlab-ee:latest'
#    restart: always
#    hostname: '127.0.0.1'
#    environment:
#      GITLAB_OMNIBUS_CONFIG: |
#        external_url 'https://127.0.0.1'
#        # Add any other gitlab.rb configuration here, each on its own line
#    ports:
#      - '80:80'
#      - '443:443'
#      - '9922:22'
#    volumes:
#      - '$GITLAB_HOME/config:/etc/gitlab'
#      - '$GITLAB_HOME/logs:/var/log/gitlab'
#      - '$GITLAB_HOME/data:/var/opt/gitlab'
#  jenkins:
#    image: 'jenkins/jenkins'
#    restart: always
#    ports:
#      - '8080:8080'
#      - '50000:50000'
#    volumes:
#      - '/data/jenkins:/var/jenkins_home'
#https://jonny-huang.github.io/docker/docker_03/
```
NGINX 設定 HTTPS 網頁加密連線，建立自行簽署的 SSL 憑證
設置 default.conf
```
# 全部導向到 https
server {
    listen  80 default_server;
    server_name  _;
    return 301   https://$host$request_uri;
}

server {
    listen       443 ssl default_server;
    listen  [::]:443 ssl default_server;
    server_name  _;

    access_log  /var/log/nginx/host.access.log  main;
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```
設置 gitlab.conf
```
# 全部導向到 https
server {
    listen  80 default_server;
    server_name  gitlag.example.com;
    return 301   https://$host$request_uri;
}

server {
    listen       443 ssl default_server;
    listen  [::]:443 ssl default_server;
    server_name  gitlab.example.com;

    location / {
        proxy_pass         https://gitlab
    }
}
```
重啟 nginx
```bash
# 用 dokcer ps 取得 nginx 的 container id，假設是 86d6c85573a4
docker restart 86d6c85573a4
```
## 處理ssh埠號 
自動導向 host git user 的 ssh 到 gitlab ssh port

# 建立專案 
這裡用一個後端的專案作為 demo
## 版控
## Dockerfile

# gitlab-runner
這裡架構兩條 pipeline：
自動化部屬(包含遠端部屬，用 ssh 指令?)
自動化原始碼品質偵測 sonarqube
# .gitlab-ci.yml

# Reference
https://segmentfault.com/a/1190000040414390

https://askubuntu.com/questions/984445/netplan-configuration-on-ubuntu-17-04-virtual-machine

https://ithelp.ithome.com.tw/articles/10219427

https://docs.gitlab.com/ee/install/docker.html

https://titangene.github.io/article/networking-in-docker-compose.html

在 container 內設置反向代理
https://stackoverflow.com/questions/45717835/docker-proxy-pass-to-another-container-nginx-host-not-found-in-upstream
處理 gitlab 的 502 bad gateway error
https://forum.gitlab.com/t/bad-gateway-behind-reverse-proxy/47054
https://forum.gitlab.com/t/gitlab-using-docker-compose-behind-a-nginx-reverse-proxy/26148/3  <=