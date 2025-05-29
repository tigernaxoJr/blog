---
title: "[Security] 使用 docker compose 部屬 Traefik"
date: 2025-05-27T14:31:00+08:00
draft: true
hero: 
menu:
  sidebar:
    name: "[Traefik] workshop"
    identifier: traefik-workshop-1
    parent: devops
    weight: 1000
---
使用 docker-compose.yml 部屬 Traefik 作為反向代理的範例，它會根據網域名稱代理其他服務，並自動管理 Let's Encrypt 憑證。

這個範例會包含兩個部分：

1. Traefik 的 docker-compose.yml： 用於部署 Traefik 本身，並配置其監聽的端口、Let's Encrypt 設定等。
2. 一個範例服務的 docker-compose.yml： 用於部署一個簡單的 Nginx 服務，並展示如何配置它以被 Traefik 代理。
注意事項：

> 請將 yourdomain.com 和 your-email@example.com 替換為你自己的實際網域名稱和電子郵件地址。  
> 你需要將你的網域名稱的 DNS 設定指向你的伺服器的 IP 位址。  
> 這個範例使用 HTTP-01 挑戰來取得 Let's Encrypt 憑證，這意味著你需要將 80 端口開放給 Traefik。如果你需要使用 DNS-01 挑戰，配置會更複雜，需要整合 DNS 提供商的 API。  
> 在生產環境中，建議將 Traefik 的配置檔（traefik.yml）放在一個獨立的 volume 中，以便於管理和備份。

## Traefik 配置
```bash
mkdir ${PROJECT_ROOT}/traefik
cd traefik
```
1. docker-compose.yml
```yaml
# traefik-compose.yml
version: '3.8'

services:
  traefik:
    image: traefik:v2.11 # 使用最新的 Traefik v2.11 版本
    container_name: traefik
    restart: always
    ports:
      - "80:80"   # HTTP - 用於 Let's Encrypt 挑戰和重定向到 HTTPS
      - "443:443" # HTTPS
      # - "8080:8080" # Traefik Dashboard (僅用於測試，生產環境不建議直接暴露)
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro # 允許 Traefik 監聽 Docker socket
      - ./traefik-data:/etc/traefik # 持久化 Traefik 配置和 Let's Encrypt 憑證
      - ./traefik.yml:/etc/traefik/traefik.yml:ro # 主配置檔
      - ./acme.json:/etc/traefik/acme.json # Let's Encrypt 憑證存儲 (必須有 600 權限)
    command:
      # 啟用 Docker 提供者
      - --providers.docker=true
      - --providers.docker.exposedbydefault=false # 默認不暴露所有容器
      # 啟用 API 和 Dashboard (生產環境不建議直接暴露)
      # - --api.dashboard=true
      # - --api.insecure=true # 允許不安全的 API 訪問 (僅用於測試)
      # 啟用日誌
      - --log.level=INFO
      # 啟用 HTTPS 重新導向
      - --entrypoints.web.address=:80
      - --entrypoints.web.http.redirections.entrypoint.to=websecure
      - --entrypoints.web.http.redirections.entrypoint.scheme=https
      - --entrypoints.websecure.address=:443
      # Let's Encrypt 配置
      - --certificatesresolvers.myresolver.acme.httpchallenge=true
      - --certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web
      - --certificatesresolvers.myresolver.acme.email=your-email@example.com # 你的電子郵件
      - --certificatesresolvers.myresolver.acme.storage=/etc/traefik/acme.json
    networks:
      - web
      - traefik_proxy_network # 這是 Traefik 將連接到的通用網路

networks:
  web:
    external: true # 使用一個外部的 Docker 網路，供所有需要被代理的服務共享
  traefik_proxy_network: # 專用於 Traefik 容器內部使用的網路
    internal: true # 這是內部網路，只用於 Traefik 容器之間通信
```
2. traefik.yml
```yaml
# traefik.yml
# 啟用 Docker 提供者，並設定監聽的網路
providers:
  docker:
    network: traefik_proxy_network # Traefik 監聽這個網路上的容器
    exposedByDefault: false # 默認不暴露所有容器

# 啟用 API 和 Dashboard (可選，生產環境不建議直接暴露)
# api:
#   dashboard: true
#   insecure: true # 允許不安全的 API 訪問 (僅用於測試)

# 日誌設定
log:
  level: INFO

# 進入點 (entrypoints)
entrypoints:
  web:
    address: ":80"
    http:
      redirections:
        entrypoint:
          to: websecure
          scheme: https
  websecure:
    address: ":443"

# 憑證解析器 (certificates resolvers)
certificatesResolvers:
  myresolver:
    acme:
      email: your-email@example.com # 你的電子郵件
      storage: /etc/traefik/acme.json
      httpChallenge:
        entryPoint: web
```
3. acme.json
創建一個空的 acme.json 文件，這個文件將用於儲存 Let's Encrypt 憑證。Traefik 需要對這個文件有讀寫權限。
```bash
touch acme.json
chmod 600 acme.json
```
4. traefik-data
這個目錄將用於持久化 Traefik 的配置和憑證，以便在容器重啟後不會丟失。
```bash
mkdir traefik-data
```
5. 創建 Traefik 共享網路
```bash
docker network create web
```

## 範例服務
```bash
mkdir ${PROJECT_ROOT}/my-app
cd my-app
```
1. docker-compose.yml
創建一個獨立的 docker-compose.yml 文件來部署一個範例 Nginx 服務，並配置它以被 Traefik 代理。
```yaml
# my-app/docker-compose.yml
version: '3.8'

services:
  nginx:
    image: nginx:latest
    container_name: my-nginx-app
    restart: always
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    labels:
      # 啟用 Traefik 代理此服務
      - traefik.enable=true
      # 定義 HTTP 路由器
      - traefik.http.routers.my-nginx-app.entrypoints=websecure
      - traefik.http.routers.my-nginx-app.rule=Host(`yourdomain.com`) # 根據網域名稱路由
      # 使用 Let's Encrypt 憑證解析器
      - traefik.http.routers.my-nginx-app.tls.certresolver=myresolver
      # 定義服務
      - traefik.http.services.my-nginx-app.loadbalancer.server.port=80 # 服務在容器內部監聽的端口
    networks:
      - web # 連接到 Traefik 監聽的外部網路

networks:
  web:
    external: true # 使用 Traefik 創建的外部網路
```
2. nginx.conf
```nginx
# my-app/nginx.conf
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name localhost;

        location / {
            return 200 "Hello from Nginx!";
            add_header Content-Type text/plain;
        }
    }
}
```
## 部屬

```bash
cd ${PROJECT_ROOT}/traefik
docker compose up -d
cd ${PROJECT_ROOT}/my-app
docker compose up -d
```

要代理其他服務，你只需要：

1. 在你的新服務的 docker-compose.yml 文件中，將該服務連接到 web 網路。
2. 為該服務添加 Traefik labels，定義其路由規則（Host()）、入口點（entrypoints）和憑證解析器（tls.certresolver）。
例如，代理另一個服務 another-app.yourdomain.com：
3. 執行 `docker-compose up -d` 啟用該服務。

```yaml
# another-app/docker-compose.yml
version: '3.8'

services:
  another_app:
    image: some-other-app-image:latest # 替換為你的應用程式映像
    container_name: another-app
    restart: always
    labels:
      - traefik.enable=true
      - traefik.http.routers.another-app.entrypoints=websecure
      - traefik.http.routers.another-app.rule=Host(`another-app.yourdomain.com`)
      - traefik.http.routers.another-app.tls.certresolver=myresolver
      - traefik.http.services.another-app.loadbalancer.server.port=8080 # 假設這個服務在容器內部監聽 8080 端口
    networks:
      - web

networks:
  web:
    external: true
```
