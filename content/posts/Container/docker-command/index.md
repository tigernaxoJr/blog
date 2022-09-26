---
title: "[Docker] Docker Basic Command"
date: 2022-04-25T06:26:00+08:00
hero: 
draft: false
menu:
  sidebar:
    name: "[Docker] Docker 基礎指令"
    identifier: container-docker-command
    parent: container
    weight: 2000
---
執行容器
```
docker run [image] [overwrite defalut commain]
```
列出正在執行的容器， --all 可以列出曾經執行過的容器
```
docker ps [--all]
```
```
docker run
docker ps --all
docker create
docker start (what different from docker run?)
docker system prune
docker logs
docker stop   (send sigterm) 10s then docker kill
docker kill
docker build -t <dockerid>/<project>:latest .

docker exec -it <containerId> /bin/bash (i, t stands for?)
```
build context!
port mapping 是為了處理 into docker，docker 出來從來沒有被限制

Docker Compose
所有的 docker-compose 都要在 yml 資料夾下作用
可啟動多個 Contailner 並連接 Container 之間的網路
docker-compose.yml
docker-compose up
docker-compose up -d # start container in the background
docker-compose up --build
docker-compose down
docker-compose ps (需要 yml ，因此要在 yml 所在的資料夾下才能下)
network
service
## restart policy
  - "no"  (no 在 yaml 裡面代表 false，所以要傳入帶括號的 "no")
  - always (reuse old container，例如 web server)
  - on-failure (用於例如完成任務就退出的 worker container)
  - unless-stopped
```
```