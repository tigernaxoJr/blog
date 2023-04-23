---
title: "[DIY] Git Action 附加編譯檔案到 Release Tag (Dotnet)"
date: 2023-01-18T09:20:00+08:00
draft: false
hero: 
discription: Git Action 附加編譯檔案到 Release Tag (Dotnet)
menu:
  sidebar:
    name: "[Git] Release Action (Dotnet)"
    identifier: devops-git-action-release-dotnet
    parent: devops
    weight: 1000
---
效果：新增一個 v 開頭的 Tag，等 Action 結束之後該 Release 會獲得相對應的 Release 壓縮檔案。
## 步驟
新增檔案`.github/workflow/Release.yml`
```yaml
name: Release

# 新增 tag 的時候觸發
on:
  push:
    tags:
      - "*"

# 讓 workflow 獲得上傳檔案的權限
permissions:
  contents: write

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        dotnet-version: ["5.0.x"]
    # 判斷 tag 如果是 v 開頭才繼續
    if: startsWith(github.ref, 'refs/tags/v')
    steps:
      # 取得 Git 中的原始碼
      - uses: actions/checkout@v3
      - name: Setup .NET Core SDK ${{ matrix.dotnet-version }}
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: ${{ matrix.dotnet-version }}
      # 還原套件
      - name: Restore
        run: dotnet restore
      # 編譯
      - name: Build
        run: dotnet build --configuration Release --no-restore --no-restore -o api
      # 壓縮編譯檔
      - name: Compress
        run: zip -r api.${{ github.ref_name }}.zip ./api
      # 建立 Release 、上傳檔案
      - name: Create Release and Upload Release Asset
        uses: softprops/action-gh-release@v1
        with:
          tag_name: ${{  github.ref_name }}
          name: ${{  github.ref_name }}
          body: ${{ github.ref_name }}
          draft: false
          prerelease: false
          files: api.${{ github.ref_name }}.zip
```