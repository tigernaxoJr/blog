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