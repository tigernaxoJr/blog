---
title: "[HA] 使用 Docker Compose 安裝 Home Assistant"
date: 2022-11-22T08:50:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[安裝] Home Assistant 安裝"
    identifier: other-home-assistant-install1
    parent: other-home-assistant
    weight: 1000
---
這裡是假設手邊已經有一台安裝 docker、docker-compose 的 Linux 系統。
採用的映象檔是 `ghcr.io/home-assistant/home-assistant:stable` ，因為我需要使用網址來區分服務(同一個 443 port 的情況下)，所以採取反向代理的方式，一方面讓之後要部屬其他應用、加上憑證、等等操作都交給 nginx 比較方便，因此不會將 8123 port 直接對外。  
1. 建立 `mynetwork`
    ```bash
    docker create network mynetwork
    ```
2. 建立 `ha`
  - `ha/docker-compose.yml`
      ```yml
      version: '3'
      services:
        ha:
          container_name: homeassistant
          #image: "homeassistant/home-assistant:stable"
          image: ${HA_IMAGE}
          volumes:
            - ./volume/ha/config:/config
            - /etc/localtime:/etc/localtime:ro
            - /run/dbus:/run/dbus:ro
          restart: unless-stopped
          privileged: true
          networks:
            - mynetwork
      networks:
        mynetwork:
          external: true
      ```
  - `ha/.env`
      ```
      HA_IMAGE="homeassistant/home-assistant:stable"
      ```
  - `ha/.gitignore`
      ```
      volume/
      ```
3. 建立 `nginx`
  - `nginx/docker-compose.yml`
      ```yml
      version: '3'
      services:
        web:
          image: nginx
          volumes:
            # - ./templates:/etc/nginx/templates
            - /usr/share/nginx/html:/usr/share/nginx/html
            - ./nginx.conf:/etc/nginx/nginx.conf
            - /etc/letsencrypt:/etc/letsencrypt
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
  - `nginx/nginx.conf`
      ```
      events {
      }

      http {
        upstream ha {
            server ha:8123;
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
          #listen 443 ssl;
          #server_name home.example.com;

          # SSL certificate and key configuration
          #ssl_certificate /etc/letsencrypt/live/home.example.com/fullchain.pem;
          #ssl_certificate_key /etc/letsencrypt/live/home.example.com/privkey.pem;

          # Additional SSL configurations (e.g., enable secure ciphers, etc.)
          #ssl_protocols TLSv1.2 TLSv1.3;
          #ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384';

          location /.well-known/acme-challenge {
            root   /usr/share/nginx/html;
          }
          location / {
              proxy_pass http://ha;
              proxy_set_header Host $host;
              proxy_http_version 1.1;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
          }
        }
      }
      ```
4. 啟動服務
    ```bash
    docker-compose -f ha/docker-compose.yml up -d
    docker-compose -f nginx/docker-compose.yml up -d
    ```

## 創建帳號 
例如我的 IP 是 192.168.56.100
現在可以進入 `http://192.168.56.100/` 開始創建帳號。


## Reference
- [home-assistant.io - installation](https://www.home-assistant.io/installation/generic-x86-64#docker-compose)
- [configuring-the-mosquitto-mqtt-docker-container-for-use-with-home-assistant](https://www.homeautomationguy.io/docker-tips/configuring-the-mosquitto-mqtt-docker-container-for-use-with-home-assistant/)
- [home-assistant-docker-zigbee2mqtt](https://medium.com/geekculture/home-assistant-docker-zigbee2mqtt-3d8e0ba02d10)
- [Zigbee2MQTT - Configuration](https://www.zigbee2mqtt.io/guide/configuration)