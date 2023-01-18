---
title: "[DIY] Git Action 附加編譯檔案到 Release Tag (Vue)"
date: 2023-01-18T09:20:00+08:00
draft: false
hero: 
discription: Git Action 附加編譯檔案到 Release Tag (Vue)
menu:
  sidebar:
    name: "[Git] Release Action (Vue)"
    identifier: devops-git-action-release-vue
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
    # 判斷 tag 如果是 v 開頭才繼續
    if: startsWith(github.ref, 'refs/tags/v')
    steps:
      # 取得 Git 中的原始碼
      - uses: actions/checkout@v3
      # 編譯
      - name: Build SPA
        run: yarn && yarn build && mv dist/ app/
      # 壓縮編譯檔
      - name: Compress
        run: zip -r app.${{ github.ref_name }}.zip ./app
      # 建立 Release 、上傳檔案
      - name: Create Release and Upload Release Asset
        uses: softprops/action-gh-release@v1
        with:
          tag_name: ${{  github.ref_name }} 
          name: ${{ github.ref_name }}
          body: ${{ github.ref_name }}
          draft: false
          prerelease: false
          files: app.${{ github.ref_name }}.zip
```