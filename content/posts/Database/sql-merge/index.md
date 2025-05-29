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
MERGE INTO TABLE1 DEST -- 目標表格
  USING( SELECT :K1 K1, :K2 K2, :K3 K3, :K4 K4, FROM DUAL) SRC
  ON( DEST.K1 = SRC.K1 AND DEST.K2 = SRC.K2 AND DEST.K4 = SRC.K4 )
-- TARGET 有，SOURCE 沒有，更新 TARGET 裡面的紀錄
WHEN MATCHED THEN
  UPDATE SET F1 = SRC.F1, F2 = SRC.F2,
-- TARGET 沒有，SOURCE 有，SOURCE 新增到 TARGET
WHEN NOT MATCHED THEN
  INSERT ( K1, K2, K4, K3, F1, F2 ) 
  VALUES ( :K1, :K2, :K4, :K3, :F1, :F2) 
```
## Reference 
- [[StackOverflow] Performing MERGE with Dapper.net](https://stackoverflow.com/questions/43738324/performing-merge-with-dapper-net)