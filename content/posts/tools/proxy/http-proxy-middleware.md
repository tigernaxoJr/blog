---
title: "[Tools] 10分鐘建造 proxy 克服跨網域資源存取(CORS)問題"
date: 2021-03-20T08:45:00+08:00
lastmod: 2021-03-20T08:45:00+08:00
draft: false 
tags: ["CORS", "Cross-Origin Resource Sharing", "http-proxy-middleware"]
categories: ["Tools"]
author: "tigernaxo"

autoCollapseToc: false
---
前後端分離的開發環境以 Ajax 呼叫資源時時會遇到跨網域存取的問題，
一些比較全面的開發環境像是 webpack、vue-cli 等等通常提供內建開發代理伺服器可供設置，
如果要對於不熟悉的開發環境進行快速除錯
(例如 vue 開發者臨時檢查其他框架的程式碼遇到跨網域問題)，
重新研究如何設置開發環境跨網域代理伺服器往往就花費多餘的時間
(不過最終還是要搭建起來阿，喂~~)，
因此紀錄一下怎麼用 node.js 建立一個通用的代理伺服器處理跨網域問題，整個過程不超過5分鐘。

# 步驟
## 首先安裝 [node.js](https://nodejs.org/en/)
## 建立專案資料夾
建立一個資料夾叫做 proxy 存放這個專案吧，手動建立也可以。
```bash
mkdir proxy
```
## 起始專案
用指令移動到該專案資料夾下，起始專案：
```bash
cd proxy
npm init 
```
## 安裝相依性
```bash
npm i express http-proxy-middleware cors
```
## 建立 app.js
```js
const express = require('express');
const cors = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');

// 建立一個 Express 伺服器
const app = express();
app.use(cors())

// 設定 Express 伺服器的 Host、Port
const PORT = 3000;
const HOST = "localhost";

// 設定代理到 google 的 Proxy 端點
app.use('/google', createProxyMiddleware({
    target: "https://www.google.com/",
    changeOrigin: true,
    pathRewrite: {
        [`^/google`]: '',
    },
}));

// 設定代理到 yahoo 的 Proxy 端點
app.use('/yahoo', createProxyMiddleware({
    target: "https://tw.yahoo.com/",
    changeOrigin: true,
    pathRewrite: {
        [`^/yahoo`]: '',
    },
}));

// 啟動代理伺服器
app.listen(PORT, HOST, () => {
    console.log(`Starting Proxy at ${HOST}:${PORT}`);
});
```
## 啟動代理伺服器
```bash
$ node app.js
[HPM] Proxy created: /  -> https://www.google.com/
[HPM] Proxy rewrite rule created: "^/google" ~> ""
[HPM] Proxy created: /  -> https://tw.yahoo.com/
[HPM] Proxy rewrite rule created: "^/yahoo" ~> ""
Starting Proxy at localhost:3000
```
## 測試
打開隨意網頁 F12，用 fetch api 透過 proxy 對 google 或 yahoo 發起 get 請求成功獲得資訊，且 Header 裡面會有`Access-Control-Allow-Origin: *`：
```js
fetch('http://localhost:3000/google/')
  .then(response => response.text())
  .then(data => console.log(data));
// Promise {<pending>}
// <!doctype html><html itemscope="" itemtype="http://schema.org/WebPage" lang="zh-TW"><head><meta charset="UT...
```
如果是直接對 google 發起的 get 請求則會因為跨網域問題不會成功：
```js
fetch('https://www.google.com/')
  .then(response => response.text())
  .then(data => console.log(data));
// Promise {<pending>}
// Access to fetch at 'https://www.google.com/' from origin 'https://developer.mozilla.org' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource. If an opaque response serves your needs, set the request's mode to 'no-cors' to fetch the resource with CORS disabled.
// GET https://www.google.com/ net::ERR_FAILED
// Using_Fetch:1 Uncaught (in promise) TypeError: Failed to fetch
```