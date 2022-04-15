---
title: "[.NET Core] JsonDocument 與 DataTable 的互相轉換"
date: 2021-08-06T14:56:00+08:00
lastmod: 2021-08-06T14:56:00+08:00
draft: false
tags: ["JsonDocument", "DataTable", "dotNetCore"]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: false
---
在 LINQ 當道的時代雖然 DataTable 比較少用了，但還是難免會碰到，
下面紀錄如何在.NET Core 裡面把 DataTable 的資料轉成 JsonElement， 
```c#
public JsonElement jsonFromDataTable(DataTable dt) {
    using (var stream = new MemoryStream()) {
        using (var writer = new Utf8JsonWriter(stream)) {
            // 起始一個裝 JElement 的陣列
            writer.WriteStartArray(); 
            foreach (DataRow row in dt.Rows) {
                // 開始寫入每個 Row 各自對應的 JElement 寫入程序
                writer.WriteStartObject(); 
                foreach (DataColumn column in row.Table.Columns) {
                    // 先寫入屬性名稱
                    writer.WritePropertyName(column.ColumnName);
                    // 判斷欄位值是否為 DBNull 來寫入值或 Null
                    if (row[column.ColumnName] == DBNull.Value)
                        writer.WriteNullValue();
                    else
                        JsonSerializer.Serialize(writer, row[column]);
                }
                // 結束一列資料對應的 JElement 寫入程序
                writer.WriteEndObject();
            }
            // 結束整個陣列的寫入
            writer.WriteEndArray();
        }
        // 最後 Stream 讀取的資料會寫成 JsonDocument 的 RootElement
        return JsonDocument.Parse( stream.ToArray() ).RootElement;
    }
}
```
使用方式：
```c#
DataTable dt = new DataTable();
// 下略對 dt 一連串操作
// 直接把 DataTable 轉換成 JsonElement
JsonElement je = jsonFromDataTable(dt);
```
