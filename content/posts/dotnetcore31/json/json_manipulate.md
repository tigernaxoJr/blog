---
title: "[.NET Core] .NET Core 中對 JsonElement 的操作"
date: 2021-08-06T14:37:00+08:00
lastmod: 2021-08-06T14:37:00+08:00
draft: false
tags: ["dotNetCore", "JsonDocument", "Json"]
categories: ["NET Core 3.1"]
author: "tigernaxo"

autoCollapseToc: false 
---
.NET Core 中對 JsonElement 的操作不像以往 Newtonsoft.Json 一樣直覺，
需要自己建立一個方便的讀寫方法，原理是寫到另一個 JsonDocument，
如果要移除某個屬性也是一樣的道理，變成從從屬性名稱判斷是不是要寫到新的 JsonDocument，
下面是添加一個屬性的範例。
```c#
public static class JsonExt
{
	public static void Add(ref this JsonElement source, string name, string value)
	{
		using (MemoryStream ms = new MemoryStream())
		{
			using (Utf8JsonWriter writer = new Utf8JsonWriter(ms))
			{
				using (JsonDocument json = JsonDocument.Parse("{}"))
				{
					writer.WriteStartObject(); // 開始
					foreach (var el in source.EnumerateObject())
						el.WriteTo(writer);
					// 寫入新屬性
					writer.WritePropertyName(name);
					writer.WriteStringValue(value);
					writer.WriteEndObject(); // 結束
				}
			}
			var resultStr = Encoding.UTF8.GetString(ms.ToArray());
			var resultEl = JsonDocument.Parse(resultStr).RootElement;
			source = resultEl;
		}
	}
}
```
通常我們會解析從其他 api 來的 json 字串，然後再進行一些操作：
```c#
// 解析一個 json string ()，拿到 JsonDocument
var jo = JsonDocument.Parse("{}") 
// 從 RootElement 屬性拿到解析出的 JsonElement 
JsonElement je = jo.RootElement;
// 對 JsonElement 添加一對 key-value "hello":"word"
je.Add("hello","word"); 
```