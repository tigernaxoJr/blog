---
title: "[架構] 多層式架構(Multi-layer Architecture)"
date: 2021-01-10T23:21:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[架構] 多層(layer)架構"
    identifier: software-arch-multi-layer
    parent: software
    weight: 1000
---
多層架構的層可以是 layer 或 tier，這兩者之間主要的差別在於 layer 指程式邏輯在應用程式的位置；
而 tier 指 layer 在系統上實際部屬執行的位址，屬於物理層級的指涉。
這一篇的層指的是 layer。

為何以 multi-layer 撰寫程式碼
- 增加程式彈性和複用性:程式社設計人員透過分離表現層、應用程式層、資料存取層的程式，
當程式需要變更時只需修改或抽換對應的程式層，而不需重寫整個應用程式。
- 易於維護:多層式架構中程式碼各司其職，容易定位問題發生點。
- 利於平行開發。
- 易於擴展。

BLL;Business Logic Layer 又稱為 Service Layer，命名習慣是 Service、Helper 結尾
DAL;Data Access Layer，命名習慣是 Repo 結尾
- one-tier:所有的邏輯全部寫在這
- two-tier:抽離 BLL，BLL負責商業邏輯與資料存取
- three-tier:從 BLL 抽離 DAL，BLL負責商業邏輯、DAL負責資料存取

# 分層
- Presentation Layer(PL)
- Business Logic Layer(BLL)
- Service Layer(SL)
- Data Access Layer(DAL)
Service Layer(SL) 是 Presentation Layer與Business Layer的中介層，使用的目的在於降低PL與BL之間的耦合，
PL將商務邏輯功能委派給BL執行，
Coarse-grained systemsfine-grained systems
一個SL操作(coarse-grained operation)通常包含複數BL操作(fine-grained operation)

# Presentation Layer
# Business Logic Layer
DTO(Data transfer object) 或 Value Object，只有屬性沒有方法
business object (BO)
# Data Access Layer
## Repository pattern
todo: define aggregate root
todo: define model (或稱 entity)
todo: specify IEnumerable、IQueryable
實作 Repository pattern 的原則如下：
- Repository 方法應該是回傳 IEnumerable 而非 IQueryable
- Repository 應該只負責基本的 CRUD 操作
- Repository 的方法回傳的型別應該是 model
- 只為 aggregate root 實作 Repository 
## UoF; unit of work
## separate/generic
generic repository
## DAL 與 ORM
由於為每個 table 建立包含相同 CRUD 功能的 DAL 類別是重複性高的工作，
如果使用 ORM 的話可以考慮不為特定的 table 建立 DAL 類別，一律改為使用 generic DAL，
如果有需要其他衍伸的功能則實作在 Service 類別當中，
且可以相關的 Table 整併為單一個 Service

## 避免過度設計
### 複雜sql語法
一般來說 Repository pattern 定義 DAL 應該只能存取最基本的 CRUD，
然後佐以 unit of work pattern 進行跨資料庫操作，
但是當應用程式需要存取資料較複雜的資料庫時，
往往需要組裝較複雜的 sql ，並且在同一個交易(transation)當中實現跨資料庫查詢、計算、資料回存以確保資料一致性，
如果這時候應用程式仍死守 Repository pattern 的設計原則很容易發生過度設計(Overengineering/over-engineered)，
大幅拖慢整體效能，
... 這裡舉例
#### 交易(transaction)
make the service(s) transaction aware (https://stackoverflow.com/questions/41301400/nhibernate-at-what-scope-i-should-use-transaction)
#### 類別歸屬
而該查詢語法的DAL歸屬類別(要寫在哪一個 Repository 的方法下)，
應該視組裝出來的 sql 最外層第一個被查詢的 table 而定。
... 這裡舉例
#### 參數
應該提供該方法適當的參數，而難處在於決定該方法的參數要接收數個參數或是額外定義一個類別作為參數用
### 群組化
可以將相關的 Table Group 起來，否則會變得很複雜而難以維護

# Reference
- [Understanding Multilayered Architecture in .NET](https://www.c-sharpcorner.com/UploadFile/1492b1/understanding-multilayered-architecture-in-net/)
- [stackoverflow - Designing DAL and BLL - Single/Multiple Data Repository for the Related Tables](https://stackoverflow.com/questions/42478863/designing-dal-and-bll-single-multiple-data-repository-for-the-related-tables)
- [stackoverflow - Should write complex query in Repository or Service layer?](https://stackoverflow.com/questions/50312714/should-write-complex-query-in-repository-or-service-layer)
- [stackoverflow - Repository and query objects pattern. How to implement complex queries](https://stackoverflow.com/questions/29089102/repository-and-query-objects-pattern-how-to-implement-complex-queries)
- [stackoverflow - NHibernate: At what scope I should use transaction?](https://stackoverflow.com/questions/41301400/nhibernate-at-what-scope-i-should-use-transaction)
- [Pete's Dev Life - Data Transfer Object使用心得及時機](https://www.petekcchen.com/2010/12/how-to-use-data-transfer-object.html)
- [SOFTWARE ENGINEERING - Business logic vs Service layer](https://softwareengineering.stackexchange.com/questions/343209/business-logic-vs-service-layer)
- [wikipedia - Multitier architecture](https://en.wikipedia.org/wiki/Multitier_architecture)
- [Rockford Lhotka - Should all apps be n-tier?](http://www.lhotka.net/weblog/ShouldAllAppsBeNtier.aspx)