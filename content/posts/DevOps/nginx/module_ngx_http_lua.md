---
title: "[Module] ngx_http_lua_module"
date: 2022-06-28T11:11:00+08:00
draft: true
hero: 
menu:
  sidebar:
    name: "[Module] ngx_http_lua_module"
    identifier: devops-nginx-module_ngx_http_lua
    parent: devops-nginx
    weight: 1000
---
想在 docker 中使用 nginx 和 lua，你可能需要安裝 ngx_http_lua_module 這個模組。這個模組可以讓你在 nginx 的配置文件中使用 lua 腳本，實現一些高級的功能，比如動態代理、負載均衡、限流等。本文將介紹如何在 docker 中安裝 ngx_http_lua_module 的方法。

[Steps to install nginx with lua-nginx-module.](https://stackoverflow.com/questions/50357732/adding-lua-module-to-nginx)
[Nginx Compatibility](https://github.com/openresty/lua-nginx-module#nginx-compatibility)
## Dockerfile
```Dockerfile
```