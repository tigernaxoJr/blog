---
title: "[DIY] 利用 orphan branch 和 worktree 在同一 Git 儲存庫控管原始碼與靜態資源分支"
date: 2022-08-25T14:23:00+08:00
draft: false
hero: 
discription: 利用 orphan branch 和 worktree 在同一 Git 儲存庫控管原始碼與靜態資源分支
menu:
  sidebar:
    name: "[Git] orphan branch/worktree"
    identifier: devops-git-orphan-worktree
    parent: devops
    weight: 1000
---
目前使用 docker 疊前端的編譯環境比較複雜，不比本機端方便，本篇的把 SSG 發布流程移植到前端專案。
 - 一鍵產生前端靜態資源到特定分支，可設定該分支進入 CI/CD 流程。
 - 在同一 Git Repo 管理部屬的靜態資源與原始碼。
P.S.這裡是以 quasar CLI 為例，專案放在 gitlab，腳本可在 git bash 環境執行，build 指令是 quasar build，輸出的 路徑是 dist/spa，不同專案架構需要作相對應調整。


## Git 設定
### 建立一個 spa orphan branch
P.S. 不需在 gitlab 上事先新增相對應的 branch
```bash
git checkout --orphan spa
git reset --hard
git commit --allow-empty -m "Initializing gh-pages branch"
git push origin spa
git checkout master
```
### 新增部屬腳本 deploy.sh
新增到專案跟目錄
```bash
#!/bin/bash
# 如果要檢查是否有 commit才進行部屬，就取消註解
# if [ "`git status -s`" ]
# then 
# 	echo "The working directory is dirty. Please commit any pending changes."	
# 	exit 1;
# fi

echo "Deleting old publication"
rm -rf dist
mkdir dist
# 清空 worktree
git worktree prune 
rm -rf .git/worktrees/dist/

# 新增 worktree
echo "Checking out spa branch into /dist"
git worktree add -B spa dist origin/spa

echo "Generating site"
quasar build && cp -r deploy/. dist/

echo "Updating spa branch"
cd dist && git add --all && git commit -m "Publishing to spa "

#echo "Pushing to github"
git push --all
```
### 修改 package.json 新增一項 script：deploy
```json
"deploy": "bash deploy.sh",
```
### 把 branch 設置為 Protected
先執行一次 `npm run deploy`，讓 git 上產生 spa 這個 orphan branch
再到這裡把 spa 設定為 Protected Branche：`Settings->Repository->Protected Branches`

## CICD 設定
### 新增 deploy 資料夾
```bash
mkdir deploy
```
### 新增 Docker 檔案
在 deploy 下新增 Dockerfile
```Dockerfile
# production stage
FROM nginx:stable-alpine as production-stage
COPY spa/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
在 deploy 下新增 .dockerignore
```
.gitlab-ci.yml
deployment.yaml
```

至此前端 CLI 專案的容器化設定完成了，
可以進一步依照 DepOps 流程設定 gitlab-runner、CICD Variable、.gitlab-ci.yml、deployment.yml 等等...，串接 CI/CD
其中 .gitlab-ci.ycm 當中需要把 stage 的 -only 指定給 spa branch 等等...

## 使用
設定完畢一行指令就能部屬，如此能夠在同一個專案管理原始碼和發布的靜態資源，如果 gitlab 上有設置 CICD 流程也可以把 spa branch 設定進自動部屬。
```bash
npm run deploy
```