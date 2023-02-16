---
title: "[Hugo] Toha Theme 10分鐘快速建構"
date: 2023-02-15T16:30:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[Hugo] Toha Theme"
    identifier: other-hugo-toha-2023
    parent: other
    weight: 1000
---

## 環境需求：
- [Hugo Version 0.109.0 (extended) or higher](https://github.com/gohugoio/hugo/releases)
- [Go language 1.18 or higher (require for hugo modules)](https://github.com/golang/go/tags)
- [Node version v18.x or later and npm 8.x or later.](https://nodejs.org/en/download/)
- git

## GitHub 設定
 - 建立一個 repo 叫做 `<GitAccount>.github.io`，進入 repo 頁面
 - 建立一個 Branch 叫做 `gh-pages` (??)
 - 左側 `Settings` -> `Pages` -> 右側 `Build and deployment` -> `Branch` -> 選擇 `gh-pages` -> `Save`
 - 進入Repo -> `Setting` -> `Code and automation` -> `Actions` -> `General` -> `Workflow permissions` -> 勾選 `Read and write permissions`

## Repo 設定
抓 template
```bash
git clone https://github.com/hugo-toha/hugo-toha.github.io.git
mv hugo-toha.github.io <GitAccount>.github.io
cd <GitAccount>.github.io
hugo mod tidy
```
設置 config.yaml
```bash
rm config.toml
wget https://github.com/hugo-toha/hugo-toha.github.io/blob/main/config.yaml
# 然後修改 config.yaml 裡面的 title、baseURL、gitRepo
```
安裝套件
```bash
hugo mod npm pack
npm install
```
加入 git 
```bash
git remote rm origin
git remote add origin https://github.com/<GitAccount>/<GitAccount>.github.io
```
推送
```bash
git add .
git commit -m 'first commit'
git push -u origin main
```

完成！ 之後推送到 main 的時候就會更新內容到 `https://<GitAccount>.github.io`