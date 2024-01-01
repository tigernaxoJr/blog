---
title: "[Keycloak] docker 安裝"
date: 2023-01-01T07:44:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[Keycloak] docker 安裝"
    identifier: web-keycloak-docker-compose
    parent: web
    weight: 1000
---

採用的映象檔是 `bitnami/keycloak` ，因為我需要使用網址來區分服務(同一個 port 的情況下)，所以採取反向代理的方式，一方面讓之後要部屬其他應用、加上憑證、等等操作都交給 nginx 比較方便。

1. 建立 docker 網路 `mynetwork`，如果設定其他名稱，以下步驟再自行調整對應。
    ```bash
    docker create network mynetwork
    ```
2. 建立 docker-compose 環境 `keycloak/.env`
    ```bash
    KEYCLOCK_IMAGE=bitnami/keycloak:23.0.3
    KEYCLOAK_DATABASE_VENDOR=postgresql
    KEYCLOAK_DATABASE_PORT=5432
    KEYCLOAK_DATABASE_USER=keycloak
    KEYCLOAK_DATABASE_PASSWORD=password
    KEYCLOAK_DATABASE_NAME=keycloak

    KEYCLOAK_ADMIN_USER=admin
    KEYCLOAK_ADMIN_PASSWORD=admin
    ```
3. `keycloak/docker-compose.yml`
    ```yaml
    version: '3'

    volumes:
      postgres_data:
          driver: local

    services:
      keycloak_db:
        image: postgres
        restart: always
        volumes:
          - postgres_data:/var/lib/postgresql/data
        environment:
          POSTGRES_DB: ${KEYCLOAK_DATABASE_NAME}
          POSTGRES_USER: ${KEYCLOAK_DATABASE_USER}
          POSTGRES_PASSWORD: ${KEYCLOAK_DATABASE_PASSWORD}
        networks:
          - mynetwork
      keycloak:
        image: ${KEYCLOCK_IMAGE}
        environment:
          KEYCLOAK_DATABASE_VENDOR: ${KEYCLOAK_DATABASE_VENDOR}
          KEYCLOAK_DATABASE_HOST: keycloak_db
          KEYCLOAK_DATABASE_PORT: ${KEYCLOAK_DATABASE_PORT}
          KEYCLOAK_DATABASE_NAME: ${KEYCLOAK_DATABASE_NAME}
          KEYCLOAK_DATABASE_USER: ${KEYCLOAK_DATABASE_USER}
          KEYCLOAK_DATABASE_PASSWORD: ${KEYCLOAK_DATABASE_PASSWORD}
          KEYCLOAK_DATABASE_SCHEMA: public
          KEYCLOAK_ADMIN_USER: ${KEYCLOAK_ADMIN_USER}
          KEYCLOAK_ADMIN_PASSWORD: ${KEYCLOAK_ADMIN_PASSWORD}
          KEYCLOAK_ENABLE_HEALTH_ENDPOINTS: 'true'
          KEYCLOAK_ENABLE_STATISTICS: 'true'
          KC_PROXY: edge
          KC_PROXY_ADDRESS_FORWARDING: 'true'
          KC_HTTP_ENABLED: 'true'
        restart: unless-stopped
        networks:
          - mynetwork
        depends_on:
          - keycloak_db

    networks:
      mynetwork:
        external: true
    ```
4. 建立 `nginx/nginx.conf`，這裡我把 `keycloak.docker.vm` 給 keycloak，裡面有一些設置 ssl 用得到的區塊放置在註解。
    ```
    events {
    }

    http {
      upstream keycloak {
          server keycloak:8080;
      }
      error_log /etc/nginx/error_log.log warn;
      client_max_body_size 20m;

      # proxy_cache_path /etc/nginx/cache keys_zone=one:500m max_size=1000m;
      proxy_cache off;

      server {
        server_name localhost;
        location / {
          root   /usr/share/nginx/html;
          index  index.html index.htm;
          try_files $uri $uri/ /index.html;
        }
      }

      server {
        listen 80;
        # listen 443 ssl;
        server_name keycloak.docker.vm;

        # SSL certificate and key configuration
        # ssl_certificate /secret/crt.crt;
        # ssl_certificate_key /secret/key.key;

        # Additional SSL configurations (e.g., enable secure ciphers, etc.)
        # ssl_protocols TLSv1.2 TLSv1.3;

        # for let's encrypt challenge
        #location /.well-known/acme-challenge {
        #  root   /usr/share/nginx/html;
        #}

        set_real_ip_from 0.0.0.0/0;
        real_ip_header X-Real-IP;
        real_ip_recursive on;

        location / {
            proxy_pass http://keycloak;
            proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Port 443;
        }
      }
    }
    ```
5. `nginx/docker-compose.yml`
    ```yaml
    version: '3'
    services:
      web:
        image: nginx
        restart: always
        volumes:
          - ./nginx.conf:/etc/nginx/nginx.conf
          #- /secret:/secret # for ssl
        networks:
          - mynetwork
        ports:
        - "80:80"
        - "443:443"
        environment:
        - NGINX_ENVSUBST_TEMPLATE_SUFFIX=.conf
        - NGINX_PORT=80

    networks:
      mynetwork:
        external: true
    ```
6. 依序啟動：

    ```bash
    # 啟動 keycloak
    docker-compose up -f keycloak/docker-compose.yml -d
    # 啟動 nginx
    docker-compose up -f nginx/docker-compose.yml -d
    ```
7. 設置 hostname
    - windows 加入 `C:\Windows\System32\drivers\etc\host`
    - linux 加入 `/etc/hosts`
    ```
    192.168.68.158 keycloak.docker.vm
    ```
8. 至此已設置完成可以嘗試登入 http://keycloak.docker.vm/ 了，如果要銜接 https 的前端應用程式，則 keycloak 必須要設置憑證使用 https 才行。

## Reference
- [Bitnami package for Keycloak](https://bitnami.com/stack/keycloak/containers)