---
title: "[Web] 把電腦的難字造字檔用 FontForge 轉為字型放到網頁上使用"
date: 2021-08-24T10:07:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[Web] FontForge 造難字"
    identifier: web-tool-eudc-frontforge
    parent: web
    weight: 1000
---
Web 在顯示姓名的時候常會遇到中文難字無法顯示，
此時開發者在本機端如果有安裝造字檔 EUDC.TTE 就可以轉為 `woff`、`woff2`、`ttf` 讓網頁正確顯示難字。
過程需要字型工具軟體 [FontForge](https://fontforge.org/en-US/)，
步驟如下：

 1. 拿到造字檔 EUDC.TTE
   - 用 `cmd` 打開 `regedit` (win10 搜尋圖示點下後，輸入 `cmd`，出現小黑窗後再輸入 `regedit`)
   - 找到機碼 HKEY_CURRENT_USER -> EUDC -> 950 資料夾下的 `SystemDefaultEUDCFont` 設定檔。
   - 從設定檔的值就是 EUDC 的存放位址取出 `EUDC.tte`，我這裡是 `C:\CIBEN\EUDC.tte`
 2. 安裝 [FontForge](https://fontforge.org/en-US/)，找到 `fontforge.exe` 的位址 (**注意，跟桌面捷徑呼叫的執行檔不一樣！**)，我的是在 `C:/Program Files (x86)/FontForgeBuilds/bin/fontforge.exe`
 3. 建立一個轉檔腳本 `tte-extract.pe`，內容如下
    ```
    # Open EUDC TTE
    Open("EUDC.tte", 4)
    # CHANGE TTFNAME 2 EUDC 
    SetTTFName(0x409,1,"EUDC")
    SetTTFName(0x409,2,"EUDC")
    SetTTFName(0x409,3,"EUDC")
    SetTTFName(0x409,4,"EUDC")
    SetTTFName(0x404,1,"EUDC")
    SetTTFName(0x404,2,"EUDC")
    SetTTFName(0x409,3,"")
    SetTTFName(0x404,4,"EUDC")
    SetFontNames("EUDC", "EUDC", "EUDC", "Regular", "655", "1.0.0")
    Generate("EUDC.ttf")
    Generate("EUDC.woff")
    Generate("EUDC.woff2")
    Close()
    ```
 4. 把 `EUDC.tte`、`tte-extract`放在同一個位址，在該目錄下用指令執行轉檔 (fontforge.exe 的位址可能需要修改)： `C:/Program\ Files\ \(x86\)/FontForgeBuilds/bin/fontforge.exe -script tte-extract.pe`
 5. 得到的 `woff`、`woff2`、`ttf` 用 css 設定為網頁字形：
    - 設定網頁字形
      ```
      font-family: "EUDC";
      font-style: normal;
      src: url('./fonts/EUDC.woff2') format('woff2'),
      url('./fonts/EUDC.woff') format('woff'),
      url('./fonts/EUDC.ttf') format('truetype');
      }
      ```
    - 套用網頁字形
      ```
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      font-family: '其他優先使用的字型', 'EUDC', sans-serif;
      font-display: auto;
      }
      ```
## 其他：讓 RDLC 可顯示字造難字
### windows
 - ttf 丟到 `C:\Windows\Fonts`，可能要重啟 IDE 才抓得到字型。
 - report 裡面的字型選擇 EUDC