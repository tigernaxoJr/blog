---
title: "[Code] 處理民國年"
date: 2023-05-10T11:06:00+08:00
hero: 
menu:
  sidebar:
    name: "[Code] 處理民國年"
    identifier: csharp-cultureinfo
    parent: csharp 
    weight: 1000
---
## 預設 CultureInfo
```cs
// Program.cs
CultureInfo.DefaultThreadCurrentCulture = new CultureInfo("zh-TW")
{
    DateTimeFormat = { Calendar = new TaiwanCalendar() }
};
```
## 民國年轉換西元年
```cs
string dtestr1 = "1010229";
// ParseExact 的時候，民國年的年分要補成4碼，3碼不合法
var dte1 = DateTime.ParseExact(dtestr1.PadLeft(8, '0'), "yyMMdd", CultureInfo.CurrentCulture);
var cedte = dte1.ToString("yyyy/MM/dd");
```

## 西元年轉民國年
```cs
var dtestr2 = "20230508";
var dte2 = DateTime.ParseExact(dtestr2, "yyyyMMdd", CultureInfo.InvariantCulture);
var rocdte = dte2.ToString("yyMMdd");
```