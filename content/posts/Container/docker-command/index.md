---
title: "[Docker] Docker Basic Command"
date: 2022-04-25T06:26:00+08:00
hero: 
draft: false
menu:
  sidebar:
    name: "[Docker] 基礎指令"
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
# execute new command
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
pull request = merge ???
Travis CI
Merge PR ?

development server configuration:
use 'Dockerfile.dev' only for development 
and specify filename by -f
In front end development, use Docker Volumes to let hot reload

```bash
docker run \
  -p 3000:3000 \
  -v [bookmark] \ # bookmark volumes, means dont map this dir 
  -v[localDir]:[containerDir] # with :
```
用 docker-compose 管理這些(build, port, volumes)
development 用 docker-compose 的話 production  用什麼？

Dockerfile 留下 COPY . . 可降低對 docker compose 的耦合度，另作他用
docker attatch
-- attatch to the container terminal(stdin/stdout/strerr) of primary proccess
npm run test 會跑在不同的 process，導致無法 attatch 到所有的 stdin/stdout/stderr
npm <= attatch to this primary process
sart.js <= real run test, second process start by npm 
!!there are no workaround for npm run test of react project

multi-step build process
FROM xxx as <temp-stagename>
COPY --from=<stage> /app/build ...distination

Travis CI/circleci ?
只能有一個 FROM 沒有加 as xxx 
Travis CI，可推到 AWS 上 
GitHub App?

before_install
script

elastic beanstalk? easy to run single container
elastic beanstalk 內建 load balancer automatically scale up everything
S3 bucket? 放 zip file 的地方
IAM manage api key