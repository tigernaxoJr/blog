---
title: "[Oracle] Managed ODP.NET"
date: 2022-07-25T06:26:00+08:00
hero: 
draft: true
menu:
  sidebar:
    name: "[Oracle] Managed ODP.NET"
    identifier: oracle-managedodp
    parent: database
    weight: 2000
---
Unmanaged ODP.NET 需要一併安裝 Oracle Client 才能藉由程式庫連上資料庫，
分為 32/64 位元，若要在 64 位元上使用 IIS Application Pool 需要設定啟用 32 位元模式
需排除 NTFS 權限、設置 PATH 環境變數。

Oracle.ManagedDataAccess.dll(Managed ODP.NET) 不需要額外安裝 Oracle Client。
Oracle.ManagedDataAccessDTC.dll 分散式交易(區分 32/64 位元)


|               | Unmanaged             | Managed                                                                                  |
|---------------|-----------------------|------------------------------------------------------------------------------------------|
| DLL           | Oracle.DataAccess.dll | Oracle.ManagedDataAccess.dll Oracle.ManagedDataAccessDTC.dll 分散式交易(區分 32/64 位元) |
| Oracle Client | 需要                  | 不需要                                                                                   |
|               |                       |                                                                                          |

Managed ODP.NET 解析 tnsnames.ora 的邏輯順序如下
ODP.NET Core will look for sqlnet.ora and tnsnames.ora files in the following precedence order:
OracleConfiguration.OracleDataSources
Directory set in OracleConnection.TnsAdmin property
Directory set for the Tns_Admin connection string attribute
Directory set in OracleConfiguration.TnsAdmin property
Current working directory
TNS_ADMIN directory setting of the OS environment variable or container environment variable
## Reference
- [暗黑執行緒 - Managed ODP.NET簡介](https://blog.darkthread.net/blog/managed-odp-net/)