---
title: "[.NET] 開發階段管理應用程式的敏感資料"
date: 2022-07-29T14:57:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[.NET] 開發階段專案敏感資料"
    identifier: dotnet-secretl-manager
    parent: dotnet
    weight: 1000
---
基於資訊安全的理由，密碼等敏感性資訊不應該出現在程式碼裡面，
應該把敏感性資料儲存在專案以外的地方，防止對 Git Server 提交專案程式碼的時候把密碼推送到伺服器上，
因此程式開發、部屬階段都應該用適當的策略存放敏感性資料讓程式讀取使用，
.NET 儲存敏感性資料大致上來說可以用這兩種方式：
 - 環境變數
 - Secret Manager

這裡紀錄要如何在 .NET 開發環境以 Secret 儲存敏感性資料，以及程式讀取的方式。
## Secret Manager
Secret Manager 就是在本地端特定路徑存放 secret.json 檔案：
```bat
%APPDATA%\Microsoft\UserSecrets\<user_secrets_id>\secrets.json
```
```Linux/MacOS
~/.microsoft/usersecrets/<user_secrets_id>/secrets.json
```
需要先針對個別專案啟用專案的 Secret Storage 支援，切換到專案目錄執行：
```bash
dotnet user-secrets init
```
在專案檔裡的 UserSecretsId 區段會得到一段 GUID，這個要作為 user_secrets_id 資料夾名稱。
```xml
<PropertyGroup>
  <TargetFramework>netcoreapp3.1</TargetFramework>
  <UserSecretsId>79a3edd0-2092-40a2-a04d-dcb46d5ca9ed</UserSecretsId>
</PropertyGroup>
```
以指令設置一組 secret，例如連線字串：
```bash
dotnet user-secrets set "ConnectionStrings:POSTGRES" "User ID=root;Password=myPassword;Host=localhost;Port=5432;Database=myDataBase;Pooling=true;Min Pool Size=0;Max Pool Size=100;Connection Lifetime=0;" --project "D:\workspace\MySolution\MyProject"
```
以檔案直接設置 secret
windows
```bat
type .\input.json | dotnet user-secrets set
```
Linux/MacOS
```bash
cat ./input.json | dotnet user-secrets set
```
在程式裡面存在 secret.json 裡面，感覺就像寫在 appsettings.json 裡面一樣，存取方式沒有有任何差別：
```c#
// 用讀取 appsetting.json 的方法讀取設定區段值取得連線字串
var connectionString = Configuration.GetSection("ConnectionStrings:POSTGRES").Get<string>();
// 如果設定區段是連線字串也可以直接使用 GetConnectionString
var connectionString = Configuration.GetConnectionString("POSTGRES");
```
## Reference 
- [MSDN - Safe storage of app secrets in development in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/security/app-secrets?view=aspnetcore-6.0&tabs=windows#read-the-secret-via-the-configuration-api)