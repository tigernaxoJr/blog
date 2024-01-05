---
title: "[.NET] C# 將 PDF 轉為列印文件送出至印表機"
date: 2024-01-05T11:11:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[.NET] PDF 列印"
    identifier: dotnet-pdf-print
    parent: dotnet
    weight: 1000
---
PdfiumViewer 是開源的 C# 控件，用於顯示和列印 PDF 文件。它基於 Chromium 瀏覽器使用的 PDF 渲染引擎 Pdfium 所開發。
而Pdfium 是 Chromium 瀏覽器使用的 PDF 渲染引擎，由 Google 和 Mozilla 共同開發。它是一個開放原始碼的函式庫，用於 PDF 文件的解碼、渲染和編輯。
PdfiumViewer 提供以下功能：
 - 顯示 PDF 文件的所有頁面。
 - 支持縮放、旋轉、翻頁等操作。
 - 支持列印 PDF 文件。

在 c# 中使用 PdfiumViewer 可以將 PDF 轉換為列印文件，送至印表機進行列印。

1. 安裝 Nuget 套件：
 - [PdfiumViewer](https://www.nuget.org/packages/PdfiumViewer/2.13.0)
 - [PdfiumViewer.Native.x86.v8-xfa](https://www.nuget.org/packages/PdfiumViewer.Native.x86.v8-xfa/)

2. 引用
    ```c#
    using PdfiumViewer;
    using System.Drawing.Printing;
    using System.IO;
    ```

3. 程式範例
    - 從記憶體列印：  
    ```c#
    var pdfBytes = new byte[] { }; // todo: 取得 PDF by docid
    var printerName = ""; // todo 取得印表機名稱

    // 列印
    using (MemoryStream memoryStream = new MemoryStream(pdfBytes))
    {
        var pageSettings = new PageSettings() { Margins = new Margins(0, 0, 0, 0) };
        var printerSettings = new PrinterSettings();
        if (!string.IsNullOrEmpty(printerName)) printerSettings.PrinterName = printerName;

        using (var document = PdfDocument.Load(memoryStream))
        {
            using (PrintDocument printDocument = document.CreatePrintDocument())
            {
                printDocument.PrinterSettings = printerSettings;
                printDocument.DefaultPageSettings = pageSettings;
                printDocument.PrintController = new StandardPrintController();
                printDocument.Print();
            }
        }
    }
    ```
    - 從檔案列印：  
    ```c#
    var file = ""; // todo 取得檔案路徑
    var printerName = ""; // todo 取得印表機名稱

    // 列印
    var pageSettings = new PageSettings() { Margins = new Margins(0, 0, 0, 0) };
    var printerSettings = new PrinterSettings();
    if (!string.IsNullOrEmpty(printerName)) printerSettings.PrinterName = printerName;

    using (var document = PdfDocument.Load(file))
    {
        using (PrintDocument printDocument = document.CreatePrintDocument())
        {
            printDocument.PrinterSettings = printerSettings;
            printDocument.DefaultPageSettings = pageSettings;
            printDocument.PrintController = new StandardPrintController();
            printDocument.Print();
        }
    }
    ```
## Reference
- [Github-PdfiumViewer](http://github.com/pvginkel/PdfiumViewer)
- [Nuget-PdfiumViewer](https://www.nuget.org/packages/PdfiumViewer/2.13.0)
- [Nuget-PdfiumViewer.Native.x86.v8-xfa](https://www.nuget.org/packages/PdfiumViewer.Native.x86.v8-xfa/)