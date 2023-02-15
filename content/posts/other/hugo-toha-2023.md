---
title: "[Hugo] Toha Theme 10分鐘快速建構"
date: 2021-01-29T23:46:00+08:00
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
 - 左側 Settings -> Pages 
 - 右側 Build and deployment -> Branch -> 選擇 gh-pages -> Save

## Repo 設定
抓 template
```bash
git clone https://github.com/hugo-toha/hugo-toha.github.io.git
mv hugo-toha.github.io <GitAccount>.github.io
cd <GitAccount>.github.io
hugo mod tidy
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
git push -u origin
```

完成！ 之後推送到 main 的時候就會更新內容到 `https://<GitAccount>.github.io`