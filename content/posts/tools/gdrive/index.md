---
title: "[Tools] 在 linux 中使用 google drive cli"
date: 2021-01-29T23:46:00+08:00
lastmod: 2021-01-29T23:46:00+08:00
draft: false 
tags: ["linux", "google drive"]
categories: ["Tools"]
author: "tigernaxo"

autoCollapseToc: false
##關鍵字：gdrive 系統已暫時停用這個應用程式的「使用 google 帳戶登入」功能
---
# 重新編譯 gdrive
## 取得憑證
- 首先到[Google API Console](https://console.developers.google.com/apis/dashboard)，
- 建立專案
- 啟動 Google Drive API。
- 啟用之後選擇左邊的"設定同意畫面"，填寫必要的欄位其他依照需求設置就好
- 建立一組 OAth2 憑證，會有 Client ID 和 Secret

## 編譯專案
- 1.安裝 [Golang](https://golang.org/dl/)
- 2.下載 gdrive 專案
  ```bash
  git clone git@github.com:prasmussen/gdrive.git
  ```
- 3.修改專案下的`handlers_drive.go`，把下列兩行改成拿到的 Client ID、Secret
  ```go
  const ClientId = "*************************************.com"
  const ClientSecret = "*************"
  ```
- 4.取得需要的 golang 套件
  ```bash
  go get github.com/prasmussen/gdrive
  ```
- 5.到專案資料夾下編譯，編譯完後就會有得到執行檔
  ```bash
  go build
  ```

# 設定
## 設置環境變數
將編譯好的執行檔上傳Linux，假設放在${HOME}/gdrive-linux-x64：
```bash
# 建立${HOME}/bin
$ mkdir -p ${HOME}/bin
# 把gdrive-linux-x64放進去重新命名為gdrive
$ mv ${HOME}/gdrive-linux-x64 ${HOME}/bin/gdrive
# 賦予gdrive執行權限
$ chmod u+x ${HOME}/bin/gdrive

# 如果PATH裡面找不到${HOME}/bin就新增並重新讀取環境設定
$ echo ${PATH} | grep -qE ${HOME}/bin[^/] && \
> echo "PATH=\${HOME}/bin:\${PATH}" >> ~/.bashrc && \
> . ~/.bashrc
```
## 連結google帳戶
安裝好Google drive CLI後需要取得雲端硬碟帳戶授權，gdrive預設會在${HOME}/.gdrive底下找授權檔，
由於目前我們沒有任何授權，所以需要先下簡單的指令觸發token請求，
取得token之後會出現一個檔案叫做${HOME}/.gdrive/token_v2.json，
並且在終端機出現雲端硬碟所有檔案及資料夾清單(預設最多出現30筆)：
```bash
# 以list命令觸發token請求
# 這裡會得到一個網址，貼到瀏覽器的網址列enter，之後選擇你要連結的帳戶，按照步驟授權後貼上授權碼，成功的話就會出現清單。
$ gdrive list
Authentication needed
Go to the following url in your browser:
https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=...

Enter verification code:7/4wDh2A_4vtaFR9JibaVC-l-lv2sV7SSCj0QsWL-J2-mcTGY9xrTi9rU
```
# 使用
## 查詢檔案
gdrive除了一些特殊資料夾，像是根目錄沒有ID直接叫做root之外，
對於檔案跟資料夾的操作都基於id，而獲得檔案與資料夾id常用的方式有三種：
- 從資料夾網址觀察id：https://drive.google.com/drive/u/1/folders/1D8kkabcEecxxxxxxNSAy8ho97gTRuyNa
- 對檔案右鍵後選擇"取得檔案共用連結，貼到文字編輯器觀察id：https://drive.google.com/open?id=1QJUxAzep1s4xxxxxxxUWUxf1H3KBrTNO
- 透過gdrive list指令配合搜尋參數(重要！可參閱文件)查詢，就是以下要介紹的方法。

### 查詢雲端檔案清單
```bash
# 列出雲端硬碟最上層資料夾(root)的內容
$ ./gdrive-linux-x64 list -q "'root' in parents"
Id                                             Name         Type   Size   Created
1zY5UMnx-xxxxxxfuetg7cyrY5MU-k8w4              tmp          dir           2018-05-29 02:32:33
1D8kkabcEecxxxxxxNSAy8ho97gTRuyNa              Backup       dir           2018-03-27 05:14:21
1gFOCwss-xxxxxxKF5td-g-Ovj_z4JoEcqpVHq1t5u4Y   Google 相簿    dir           2017-07-07 14:02:17

# 列出特定資料夾的內容，1D8kkabcEecxxxxxxNSAy8ho97gTRuyNa是資料夾id
$ ./gdrive-linux-x64 list -q "'1D8kkabcEecxxxxxxNSAy8ho97gTRuyNa' in parents"
Id                                  Name        Type   Size      Created
1sqZTRRd5ucxxxxxx7l4ApnlLs4kVOsyF   note0001    bin    196.0 B   2018-07-18 06:41:12
1V-CvduOE9exxxxxxAflObt2wbGbD49zz   note0002    bin    199.0 B   2018-07-18 06:41:11
1SOq0opXxXQxxxxxxiCy5eY3ivO-KFVLy   back        dir              2018-07-18 06:40:56
1tyJcRaO9Dfxxxxxxo6yvndSkr8zpos_D   test.sh     bin    4.6 KB    2018-07-18 06:38:25
```
## 上傳/下載
### 下載
```bash
# 下載某個檔案
$ gdrive download 1tyJcRaO9Dfxxxxxxo6yvndSkr8zpos_D
Downloading myTestFile1 -> myTestFile1
Downloaded 1tyJcRaO9Dfxxxxxxo6yvndSkr8zpos_D at 402.0 B/s, total 402.0 B

# 下載整個資料夾
$ gdrive download -r 1D8kkabcEecxxxxxxNSAy8ho97gTRuyNa
Downloading myTestFile1  -> myTestFolder /myTestFile1
Downloading myTestFile2  -> myTestFolder /myTestFile2
Downloading myTestFile3  -> myTestFolder /myTestFile3
Downloading myTestFile4  -> myTestFolder /myTestFile4
```
### 上傳
```bash
# 上傳某個檔案到某個資料夾
$ gdrive upload -p 1D8kkabcEecxxxxxxNSAy8ho97gTRuyNa myTestFile4
Uploading myTestFile5
Uploaded 1tyJcRaO9Dfxxxxxxo6yvndSkr8zpos_D at 87.8 KB/s, total 151.3 KB

# 上傳整個資料夾到某個資料夾底下
$ gdrive upload -r -p 1D8kkabcEecxxxxxxNSAy8ho97gTRuyNa myTestFolder
Creating directory myTestFolder
Uploading myTestFolder/myTestFile1
Uploading myTestFolder/myTestFile2
Uploading myTestFolder/myTestFile3
Uploading myTestFolder/myTestFile4
```
## 資料夾同步

### 資料夾同步到雲端
```bash
# 建立一個空資料夾並上傳雲端，作為雲端同步資料夾
$ mkdir syncTest
$ gdrive upload -r syncTest

# 查詢剛剛上傳的空資料夾ID
$ gdrive -q "name = 'syncTest'"
Id                                  Name       Type   Size   Created
1Uv5MxUXcxxxxxxcjM2nT_3hcuz-SMNnV   syncTest   dir           2019-02-18 09:52:26

# 把本地資料夾的內容同步到雲端
$ gdrive sync upload local_folder 1Uv5MxUXcxxxxxxcjM2nT_3hcuz-SMNnV
Starting sync...
Collecting local and remote file information...
Found 7 local files and 0 remote files

1 remote directories are missing
[0001/0001] Creating directory syncTest/ae006468

6 remote files are missing
[0001/0006] Uploading ae006468/0.error -> syncTest/ae006468/0.error
...
Sync finished in 13.435891267s
```
### 雲端同步到資料夾
```bash
# 建立一個空資料夾準備接收雲端資料
$ mkdir syncTest2

# 把雲端內容同步到本地資料夾
$ gdrive sync download 1Uv5MxUXcxxxxxxcjM2nT_3hcuz-SMNnV syncTest2
Starting sync...
Collecting file information...
Found 0 local files and 7 remote files

1 local directories are missing
[0001/0001] Creating directory syncTest2/ae006468

6 local files are missing
[0001/0006] Downloading ae006468/result.ok -> syncTest2/ae006468/result.ok
Sync finished in 7.269982268s
```
# Reference
- [底棲生物的生物資訊筆記 - [Google] 用Linux CLI操作google drive雲端硬碟](http://bioinfotw.blogspot.com/2019/02/google-linux-cligoogle.html)
- [GitHub - prasmussen/gdrive](https://github.com/prasmussen/gdrive)
- [Mount Google Drive using GDrive on Linux Server with Own OAuth Credentials](https://www.mynotepaper.com/mount-google-drive-using-gdrive-on-linux-server-with-own-oauth-credentials)