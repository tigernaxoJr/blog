---
title: "[SQL] Ranking"
date: 2022-06-17T15:42:00+08:00
hero: 
draft: false
menu:
  sidebar:
    name: "[SQL] Ranking"
    identifier: dbsql-ranking
    parent: database
    weight: 2000
---
先建立一個練習表格：
```sql
CREATE TABLE Department
(
  id SERIAL PRIMARY KEY, 
  name VARCHAR NOT NULL
);
CREATE TABLE Employee
(
  id SERIAL PRIMARY KEY, 
  name VARCHAR NOT NULL, 
  salary INT, 
  dep_id INT, 
);
INSERT INTO Employee(name, salary, dep_id) VALUES ('Mandy', 45000, 2);
INSERT INTO Employee(name, salary, dep_id) VALUES ('Emily', 43000, 1);
INSERT INTO Employee(name, salary, dep_id) VALUES ('Sylvia', 26000, 2);
INSERT INTO Employee(name, salary, dep_id) VALUES ('Eva', 48000, 3);
INSERT INTO Employee(name, salary, dep_id) VALUES ('Sandra', 33000, 3);
INSERT INTO Employee(name, salary, dep_id) VALUES ('Lily', 28000, 2);
INSERT INTO Employee(name, salary, dep_id) VALUES ('April', 50000, 1);
INSERT INTO Employee(name, salary, dep_id) VALUES ('Cindy', 43000, 1);
INSERT INTO Employee(name, salary, dep_id) VALUES ('Kay', 40000, 3);

INSERT INTO Department(name) VALUES ('IT');
INSERT INTO Department(name) VALUES ('RD');
INSERT INTO Department(name) VALUES ('QA');
```
## 資料排序
直接用 ORDER BY 無法得到秩(排名)
```sql
SELECT ID, NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC
```
{{< highlight sql >}}
id	name		salary
4	"April"		50000
3	"Eva"		48000
2	"Mandy"		45000
7	"Cindy"		43000
1	"Emily"		43000
9	"Kay"		40000
6	"Sandra"	33000
8	"Lily"		28000
5	"Sylvia"	26000
{{</highlight>}}
## 秩函式
### ROW_NUMBER
ROW_NUMBER 按照資料行號排序，同一個值可能會給不同數字
```sql
SELECT ROW_NUMBER() OVER (ORDER BY SALARY DESC) RANK, ID, NAME, SALARY FROM EMPLOYEE
```
{{< highlight sql "hl_lines=5-6" >}}
rank	id	name		salary
1		4	"April"		50000
2		3	"Eva"		48000
3		2	"Mandy"		45000
4		7	"Cindy"		43000
5		1	"Emily"		43000
6		9	"Kay"		40000
7		6	"Sandra"	33000
8		8	"Lily"		28000
9		5	"Sylvia"	26000
{{</highlight>}}
### RANK
連號之後跳號
```sql
SELECT RANK() OVER (ORDER BY SALARY DESC) RANK, ID, NAME, SALARY FROM EMPLOYEE
```
{{< highlight sql "hl_lines=5-7" >}}
rank	id	name		salary
1		4	"April"		50000
2		3	"Eva"		48000
3		2	"Mandy"		45000
4		7	"Cindy"		43000
4		1	"Emily"		43000
6		9	"Kay"		40000
7		6	"Sandra"	33000
8		8	"Lily"		28000
9		5	"Sylvia"	26000
{{</highlight>}}
### DENSE_RANK
連號之後不跳號
```sql
SELECT DENSE_RANK() OVER (ORDER BY SALARY DESC) RANK, ID, NAME, SALARY FROM EMPLOYEE
```
{{< highlight sql "hl_lines=5-7" >}}
rank	id	name		salary
1		4	"April"		50000
2		3	"Eva"		48000
3		2	"Mandy"		45000
4		7	"Cindy"		43000
4		1	"Emily"		43000
5		9	"Kay"		40000
6		6	"Sandra"	33000
7		8	"Lily"		28000
8		5	"Sylvia"	26000
{{</highlight>}}
### NTILE
排序然後分成N組
```sql
SELECT NTILE(3) OVER (ORDER BY SALARY DESC) RANK, ID, NAME, SALARY FROM EMPLOYEE 
```
{{< highlight sql>}}
rank	id	name		salary
1		4	"April"		50000
1		3	"Eva"		48000
1		2	"Mandy"		45000
2		7	"Cindy"		43000
2		1	"Emily"		43000
2		9	"Kay"		40000
3		6	"Sandra"	33000
3		8	"Lily"		28000
3		5	"Sylvia"	26000
{{</highlight>}}
## 分組排名(Partition By)
```sql
SELECT 
  RANK() OVER (PARTITION BY A.DEP_ID ORDER BY A.SALARY) RANK, 
  B.NAME DEP_NAME, A.NAME, A.SALARY FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEP_ID=B.ID
```
{{< highlight sql "hl_lines=5-7">}}
rank	dep		name		salary
1		"IT"	"Emily"		43000
1		"IT"	"Cindy"		43000
3		"IT"	"April"		50000
1		"RD"	"Sylvia"	26000
2		"RD"	"Lily"		28000
3		"RD"	"Mandy"		45000
1		"QA"	"Sandra"	33000
2		"QA"	"Kay"		40000
3		"QA"	"Eva"		48000
{{</highlight>}}

## Reference 
- [sqlshack-Overview Of Sql Rank Functions](https://www.sqlshack.com/overview-of-sql-rank-functions/)