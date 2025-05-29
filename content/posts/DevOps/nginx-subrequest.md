---
title: "[Nginx] Subrequest"
date: 2022-06-28T11:11:00+08:00
draft: true
hero: 
menu:
  sidebar:
    name: "[Nginx] Subrequest"
    identifier: devops-nginx-subrequest
    parent: devops
    weight: 1000
---
在Nginx中，您可以使用subrequest來發送一個子請求，並將其嵌入到父請求中。這個功能可以讓您在處理一個請求的同時，發送一個額外的請求並將其返回值合併到主請求中，從而實現更靈活的功能。

具體來說，當您發送一個subrequest時，Nginx會創建一個新的子請求，並將其發送到指定的URI上。當子請求完成後，它的返回值會被合併到父請求中。您可以使用Nginx的變數來訪問subrequest的返回值，並在父請求的處理中使用它們。

以下是一個簡單的例子，演示如何使用subrequest來獲取另一個URI的返回值：
```conf
location /foo {
    set $backend_response "";
    proxy_pass http://backend.example.com$request_uri;
    proxy_set_header X-Original-URI $request_uri;
    proxy_set_header X-Backend-Response $backend_response;
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    # Send a subrequest to a URI and set the $backend_response variable to its response body
    subrequest_output_buffer_size 64k;
    subrequest_via_location on;
    subrequest $uri/subrequest {
        proxy_pass http://backend.example.com$uri;
        proxy_set_header X-Original-URI $uri;
        proxy_method GET;
    }
    set $backend_response $upstream_http_content_type;
}
```
在這個例子中，我們使用了Nginx的subrequest功能來獲取一個URI的返回值。當處理/foo URI的請求時，我們使用subrequest指令來發送一個子請求到$uri/subrequest，並將其返回值保存在$backend_response變數中。在這個例子中，我們使用proxy_pass指令來指定子請求的URI，並使用proxy_set_header指令來設置子請求的HTTP頭。

然後，我們使用proxy_pass指令將主請求代理到http://backend.example.com，並使用proxy_set_header指令設置一些HTTP頭。在主請求的處理中，我們可以使用$backend_response變數來訪問子請求的返回值。

總的來說，subrequest功能可以讓您在處理一個請求的同時，發送一個額外的請求並將其返回值合併到主請求


## Bing version	 
以下是一个使用 subrequest 的例子，它会在 rewrite 之前呼叫外部 API 决定要 rewrite 的 URL。这个例子会把请求的网址发送给外部 API 并且从外部 API 取得要 rewrite 的 URL，然后再 reverse proxy 到该網址¹。

```
location /rewrite {
    resolver 8.8.8.8;
    set $backend "http://backend";
    set $rewrite_uri "/";

    # Call external API to get the URI to rewrite to
    # The URI is returned in the body of the response
    # The response is expected to be a plain text string
    # containing the URI to rewrite to
    subrequest /api/rewrite_uri;

    # Rewrite the URI based on the response from the API
    if ($subrequest_body ~* "^/.*$") {
        set $rewrite_uri $subrequest_body;
    }

    # Reverse proxy to the rewritten URI
    proxy_pass $backend$rewrite_uri;

}
```
nginx 的 ngx_http_proxy_module 模块提供了缓存子请求的功能。您可以使用 proxy_cache 指令来启用缓存。例如，以下配置启用了缓存，并将缓存保存在 /data/nginx/cache 目录中：

```
proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=my_cache:10m inactive=60m;
server {
    location / {
        proxy_pass http://backend;
        proxy_cache my_cache;
        proxy_cache_valid 200 60m;
        proxy_cache_valid 404 1m;
    }
}
```

这个配置将缓存有效期设置为 60 分钟，如果后端返回 404，则缓存有效期为 1 分钟。您可以根据需要调整这些值。