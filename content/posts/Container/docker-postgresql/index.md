---
title: "[Docker] 安裝PostgreSQL"
date: 2022-04-25T06:26:00+08:00
hero: 
draft: false
menu:
  sidebar:
    name: "[Docker] Postgresql"
    identifier: container-docker-postgresql
    parent: container
    weight: 2000
---

# 安裝 postgreSQL

## 拉取 postgres image
```bash
$ docker pull postgres
Using default tag: latest
latest: Pulling from library/postgres
1fe172e4850f: Pull complete
c2bb685f623f: Pull complete
3027ff705410: Pull complete
062371e3461d: Pull complete
39d54e944de7: Pull complete
6530357dda9a: Pull complete
b1d302dc78c6: Pull complete
f6d91cb1d3c1: Pull complete
9bbd62b0af28: Pull complete
3cfdfc8fbef3: Pull complete
635f8fae1d06: Pull complete
96b6711661dd: Pull complete
c08147da7b54: Pull complete
Digest: sha256:ab0be6280ada8549f45e6662ab4f00b7f601886fcd55c5976565d4636d87c8b2
Status: Downloaded newer image for postgres:latest
docker.io/library/postgres:latest
```
檢查 docker images
```bash
$ docker images
REPOSITORY         TAG       IMAGE ID       CREATED        SIZE
postgres           latest    74b0c105737a   4 days ago     376MB
```
## 建立 volume
```bash
docker volume create --name pg-data
```
## 執行 Image
環境變數
```bash
docker run \
  --name postgres \  # docker 執行名稱
  --restart always \ # 設定自動重啟
  -d -p 5432:5432 \  # 直接映射連接埠5432
  -v pg-data:/var/lib/postgresql/data \ # 把 volume 指向特定的檔案系統位置
  -e POSTGRES_PASSWORD=postgresql \     # 給環境變數
  postgres    # 要執行的 image 名稱
```

# 安裝 pgadmin4
映射連接埠80到對外的5080
```bash
docker run -p 5080:80 \
    -e "PGADMIN_DEFAULT_EMAIL=tigernaxo@gmail.com" \
    -e "PGADMIN_DEFAULT_PASSWORD=postgresql" \
    -d dpage/pgadmin4
```
# Reference
- [](https://morosedog.gitlab.io/docker-20190505-docker12/)
- [](https://geshan.com.np/blog/2021/12/docker-postgres/)