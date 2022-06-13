---
title: "[SQL] MERGE"
date: 2022-06-14T00:20:00+08:00
hero: 
draft: false
menu:
  sidebar:
    name: "[SQL] Merge"
    identifier: dbsql-merge
    parent: database
    weight: 2000
---
一段神奇的語法，可以指定對舊資料、新的資料分別進行不同的動作(通常是更新、新增)，
不指定的話預設是 BY TARGET，
動作目標都是 TARGET。

在更新清單的時候特別好用。
```sql
MERGE INTO 
  DETAIL AS TARGET  -- 目標表格
  USING ( VALUES (@k1, @k2, @k3, @f1)) AS SOURCE (k1, k2, k3, f1) -- 資料來源
  ON SOURCE.k1 = TARGET.k1 AND SOURCE.k2 = TARGET.k2 AND SOURCE.k3 = TARGET.k3 -- 兩造欄位核對條件
-- TARGET 有，SOURCE 也有，SOURCE 更新到 TARGET
WHEN MATCHED THEN -- 以 TARGET 為目標，更新 SOURCE 裡面被 TARGET 對應(BY TARGET)的資料?(這邊 BY 哪裡都一樣)
  UPDATE SET f1 = SOURCE.f1
-- TARGET 沒有，SOURCE 有，SOURCE 新增到 TARGET
WHEN NOT MATCHED THEN -- 以 TARGET 為目標，新增 SOURCE 裡面無法被 TARGET 對應(BY TARGET)的資料
  INSERT (k1, k2, k3, f1)
  VALUES (SOURCE.k1, SOURCE.k2, SOURCE.k3, SOURCE.f1)
-- TARGET 有，SOURCE 沒有，刪除 TARGET 裡面的紀錄
WHEN NOT MATCHED BY SOURCE -- 以 TARGET 為目標，刪除 TARGET 裡面無法被 SOURCE 對應(BY SOURCE)的資料
  THEN DELETE;

```
ASP 裡面結合 Dapper 可以直接丟 IEnumerable 進去。
```c#
const connectionString = "......";
const sql = @"
  MERGE INTO 
    DETAIL AS TARGET 
    USING ( VALUES (@k1, @k2, @k3, @f1)) AS SOURCE (k1, k2, k3, f1)
    ON SOURCE.k1 = TARGET.k1 AND SOURCE.k2 = TARGET.k2 AND SOURCE.k3 = TARGET.k3 
  WHEN MATCHED THEN
    UPDATE SET f1 = SOURCE.f1
  WHEN NOT MATCHED THEN
    INSERT (k1, k2, k3, f1)
    VALUES (SOURCE.k1, SOURCE.k2, SOURCE.k3, SOURCE.f1)
  WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;
    "; 
using (var cn = new OracleConnection(connectionString))
{   
    List<Detail> details = new List<Detail> {
        {new Detail() {k1 = 1, k2 = 1024, k3 = 42, f1 = 1000} },
        {new Detail() {k1 = 9999, k2 = 10268, k3 = 42, f1 = 1000} }
    };
    await cn.ExecuteAsync(sql, details);
}
```
## Reference 
- [[StackOverflow] Performing MERGE with Dapper.net](https://stackoverflow.com/questions/43738324/performing-merge-with-dapper-net)