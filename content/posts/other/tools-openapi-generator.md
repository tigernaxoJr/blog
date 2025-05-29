---
title: "[Tools] 使用 OpenApi Generator 產生 .Net Core Client"
date: 2023-04-07T11:00:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[工具] openapi generator"
    identifier: other-tools-openapi-generator
    parent: other
    weight: 1000
---
## 手動設置
需要 java 環境、npm 安裝執行檔，可參照[CLI Installation](https://openapi-generator.tech/docs/installation)
```bash
openapi-generator-cli generate \
  -i <spec file|url> -o <outdir> \  	# 設定輸入 json/xml (檔案或網址)、輸出資料夾
  -g csharp-netcore \   				# 輸出 csharp .net core 專案
  --skip-validate-spec  				# 不檢查規格
```
## Docker 
更簡單，一行搞定：
```bash
docker run --rm \
  -v ${PWD}:/local openapitools/openapi-generator-cli generate \
  -i <spec file|url> -o <outdir> \  	# 設定輸入 json/xml (檔案或網址)、輸出資料夾
  -g csharp-netcore \   				# 輸出 csharp .net core 專案
  --skip-validate-spec  				# 不檢查規格
```
## Reference
- [CLI Installation](https://openapi-generator.tech/docs/installation)
- [Documentation for the csharp-netcore Generator](https://openapi-generator.tech/docs/generators/csharp-netcore/)