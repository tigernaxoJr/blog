---
title: "[架構] 多層式架構(Multi-layer Architecture)"
date: 2023-03-28T23:34:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[架構] 多層(layer)架構"
    identifier: software-arch-multi-layer
    parent: software
    weight: 1000
---
中文多層架構的層可翻作 layer 或 tier，兩者主要的差別在於 layer 指程式邏輯在應用程式的位置；而 tier 指 layer 在系統上實際部屬執行的位址，屬於物理層級的指涉。這一篇的層說的是 layer，談如何在軟體層面利用分層 (layer) 妥善安排程式碼，以 multi-layer 撰寫程式碼能將複雜的邏輯隔離開達成關注點分離(SoC, Separation of concerns)，好處有：
  - 降低耦合：程式拆成各司其職的單元，降低彼此耦合，增加程式單元彈性(擴展性)、複用性。
  - 易於維護：多層式架構中程式碼各司其職，容易定位問題發生點、而非從整個應用程式邏輯找。
  - 敏捷開發：程式可快速回應需求修改(理由與易於維護類似，但是在開發時獲得的好處)。
  - 平行開發：解耦的程式有助於降低協作併版衝突。

# 分層
## 三層式架構

一般來說最常用的三層式架構組成為：
- 表現層 (PL; Presentation Layer)：ASP 內就是 Controller 結尾。
- 商業邏輯繩 (BLL; Business Logic Layer)：又稱為 Service Layer，命名習慣是 Service、Helper 結尾。
- 資料存取層(DAL; Data Access Layer)：命名習慣是 Repo 結尾。

另外有人將 Domain、Common 稱為一層，但這個部分其實不太像層，因為會被每一層引用，在架構上呈現比較不像層那樣扁平，裡面包含：
Model、Entity、DTO(Data transfer object) 或 Value Object，這裡只有屬性沒有方法。

## 四層式架構
為了降低 PL 與 BL 之間的耦合，有時會在 Business Logic Layer(BLL) 上再疊一層 Service Layer(SL)，作為 Presentation Layer 與 Business Layer 的中介層，這時 Business Logic Layer 的命名就不以 Serviece 結尾，通常較大型專案才需要如此分法。  
而 SL 和 BLL 的差別在於商業邏輯精細度，一個SL操作 (coarse-grained operation) 通常包含複數BL操作 (fine-grained operation)。
- Presentation Layer(PL)
- Service Layer(SL)
- Business Logic Layer(BLL)
- Data Access Layer(DAL)

## 整理
| 中文      | 英文                      | Naming Convention | 3 layer | 4 layer |
| --------- | ------------------------- | ----------------- | ------- | ------- |
| 表現層    | PL, Presentation Layer    | Controller        | 1       | 1       |
| 服務層    | BLL, Business Logic Layer | Service           | -       | 2       |
| 業務層    | BLL, Business Logic Layer | Helper, Service   | 2       | 3       |
| 資料層    | DAL, Data Access Layer    | Repoitory         | 3       | 4       |
| 共用(層?) | Common Layer              | Domain, Common    | o       | o       |

# 避免過度設計
並非所有的程式都必須要分為三層，較小型、單純的專案分層會增加複雜度，可視專案複雜度分 1~3 層，分層邏輯如下：
- one-layer：也就是不分層，所有邏輯全寫在一起。
- two-layer：抽離 BLL，BLL負責商業邏輯與資料存取。
- three-layer：從 BLL 抽離 DAL，BLL負責商業邏輯、DAL負責資料存取。


# Business Logic Layer
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
## DAL 與 ORM **
由於為每個 table 建立包含相同 CRUD 功能的 DAL 類別是重複性高的工作，
如果使用 ORM 的話可以考慮不為特定的 table 建立 DAL 類別，一律改為使用 generic DAL，
如果有需要其他衍伸的功能則實作在 Service 類別當中，
且可以相關的 Table 整併為單一個 Service

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
開啟交易的地方應該在 BLL
#### 類別歸屬
而該查詢語法的DAL歸屬類別(要寫在哪一個 Repository 的方法下)，
應該視組裝出來的 sql 最外層第一個被查詢的 table 而定。
... 這裡舉例
#### 參數
應該提供該方法適當的參數，而難處在於決定該方法的參數要接收數個參數或是額外定義一個類別作為參數用
### 群組化
可以將相關的 Table Group 起來，否則會變得很複雜而難以維護

# memo
Interface 應該定義在上層組件中，interface、entity 的依賴關係必須是終點以避免閉鎖環出現，如此一來在追蹤閉鎖環的時候可以排除只依賴於 interface, enetity 的依賴關係? 
DI Container 的地位是"組合根"應該是唯一和所有所有模組都有依賴關係的組件。 
Dto 各層都存在，是為了隔離沒有直接依賴的層，只依賴於 interface 但卻無法迴避直接依賴 Dto? 因為方 interface 是為了抽換不同方法，而 dto 沒有方法嗎？



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
- [How to build and deploy a three-layer architecture application with C#](https://enlabsoftware.com/development/how-to-build-and-deploy-a-three-layer-architecture-application-with-c-sharp-net-in-practice.html)
- [菜雞新訓記 (5): 使用 三層式架構 來切分服務的關注點和職責吧](https://igouist.github.io/post/2021/10/newbie-5-3-layer-architecture/#%E9%97%9C%E6%96%BC%E9%87%8D%E8%A4%87%E5%BB%BA%E7%AB%8B-dto-%E7%9A%84%E5%95%8F%E9%A1%8C)