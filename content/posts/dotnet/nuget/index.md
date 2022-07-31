---
title: "[.NET] 製作 Nuget package"
date: 2022-07-22T14:07:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[.NET] 製作 Nuget package"
    identifier: dotnet-nuget
    parent: dotnet
    weight: 1000
---
## 安裝 nuget.exe CLI
安裝 [nuget.exe CLI](https://docs.microsoft.com/en-us/nuget/install-nuget-client-tools#nugetexe-cli)，並在環境變數 PATH 新增路徑。

## 建立 nuspec 設定檔
example
```xml
<?xml version="1.0" encoding="utf-8"?>
<package >
  <metadata>
    <id>MyPackage</id> <!--package id -->
    <version>1.0.0</version> <!--版本號-->
    <title>MyPackage</title> <!-- package title -->
    <authors>Chen, Yu Cheng</authors> <!-- 作者 -->
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <license type="expression">MIT</license>
    <!-- <icon>icon.png</icon> -->
    <!--<projectUrl>http://project_url_here_or_delete_this_line/</projectUrl>-->
    <description>MyPackage</description>
    <releaseNotes>Test release of MyPackage package.</releaseNotes>
    <copyright>-</copyright>
    <tags></tags>
	  <dependencies>
	    <!-- 定義 .net framework 4.0 使用時需要的相依姓套件 -->
		<group targetFramework=".NETFramework4.0.0" >
		  <dependency id="Dapper" version="1.50.2" />
		  <dependency id="Newtonsoft.Json" version="7.0.1" />
		</group>
	  </dependencies>
  </metadata>
</package>
```

## 打包檔案
假設最低系統需求為 .net framework 4.0，將 Release 複製檔案複製到對應版本的資料夾內，目錄結構如下：
```
根目錄
├─MyPack.1.0.0.nupkg
└─lib
  └─net40
    └─MyPack.dll
```
編譯專案，打包指令：
```bash
nuget pack MyPack.nuspec
```
會多一個 MyPack.1.0.0.nupkg
```
根目錄
├─MyPack.nuspec
├─MyPack.1.0.0.nupkg
└─lib
  └─net40
    └─MyPack.dll
```
# 上傳到 nuget
用指令上傳(要先拿到 API-KEY)
```
nuget push YourPackage.nupkg --source http://nuget.com.tw/api/v3/index.json --api-key API-KEY
```



# Reference
- [MSDN - Create package-Create a package using the nuget.exe CLI](https://docs.microsoft.com/en-us/nuget/create-packages/creating-a-package)
- [MSDN - Nuspace](https://docs.microsoft.com/zh-tw/nuget/reference/nuspec)