---
title: "[SQL] 用 CTE (Common Table Expression) 達成遞迴查詢，建立 MenuTree"
date: 2022-04-25T06:26:00+08:00
hero: 
draft: false
menu:
  sidebar:
    name: "[SQL] CTE"
    identifier: dbsql--cte
    parent: database
    weight: 2000
---
建立一個暫存表 testCTE，並暫存查詢語句(所有資料)的結果
MSSQL CTE 名稱前不需加上 RECURSEIVE 關鍵字，必須使用 UNION ALL
PostgreSQL：CTE 名稱前需加上 RECURSIVE 關鍵字，可用 UNION 或 UNION ALL
```sql
WITH CTE (id, name, parentId, lvl) AS
(
  -- 取得第一層的資料(Anchor member)(假設沒有 parentId 的是第一層)
  SELECT id, name parentId, 0 AS lvl FROM menus WHERE parentId IS NULL
  UNION ALL
  -- 遞迴取得 Recursive member
  (
    SELECT A.id, A.name, A.parentId, B.lvl + 1 AS lvl FROM menus A
    INNER JOIN CTE B on A.parentIdi = B.d
  )
)
SELECT * FROM CTE WHERE id=1 ORDER BY LEVEL
```
## Reference 
- [[StackOverflow] How to create a query from a menu tree using RECURSIVE CTE?](https://stackoverflow.com/questions/32681915/how-to-create-a-query-from-a-menu-tree-using-recursive-cte)
- [[SQL] 使用 CTE 遞迴查詢 (PostgreSQL / MSSQL)](https://www.gss.com.tw/blog/sql-cte-recursive-query-postgresql-mssql)