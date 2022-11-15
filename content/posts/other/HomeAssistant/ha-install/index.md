---
title: "[HA] 準備系統環境"
date: 2021-01-29T23:46:00+08:00
draft: true 
hero: 
menu:
  sidebar:
    name: "[安裝] 使用 Docker 安裝"
    identifier: other-home-assistant-install1
    parent: other-home-assistant
    weight: 1000
---
這裡是假設手邊已經有一台安裝 docker、docker-compose 的 Linux 系統。
建立專案資料夾 HA 
HA/docker-compose.yaml
```yaml
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - $PWD/var/ha/config:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    ports:
      - 8123:8123
  mosquitto:
    container_name: mosquitto
    image: eclipse-mosquitto
    volumes:
      - $PWD/opt/mosquitto:/mosquitto
    ports:
      - 1883:1883
      - 9001:9001
  zigbee2mqtt:
    container_name: zigbee2mqtt
    depends_on:
      - mosquitto
    image: koenkk/zigbee2mqtt
    volumes:
      - $PWD/zigbee2mqtt/data:/app/data
      - /run/udev:/run/udev:ro
    ports:
      - 8080:8080
    device:
      - /dev/ttyUSB0:/dev/ttyUSB0
    restart: always
    privileged: true
```
HA//opt/mosquitto/config/mosquitto.conf
```conf
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
listener 1883

## Authentication ##
#allow_anonymous false
#password_file /mosquitto/config/password.txt
```
## 創建帳號 
例如我的 IP 是 192.168.56.100
http://192.168.56.100:8123/


## Reference
- [home-assistant.io - installation](https://www.home-assistant.io/installation/generic-x86-64#docker-compose)
- [configuring-the-mosquitto-mqtt-docker-container-for-use-with-home-assistant](https://www.homeautomationguy.io/docker-tips/configuring-the-mosquitto-mqtt-docker-container-for-use-with-home-assistant/)
- [home-assistant-docker-zigbee2mqtt](https://medium.com/geekculture/home-assistant-docker-zigbee2mqtt-3d8e0ba02d10)