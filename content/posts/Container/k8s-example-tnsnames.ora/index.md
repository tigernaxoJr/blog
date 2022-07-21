---
title: "[K8s] 以 Secrete 共享 tnsnames.ora"
date: 2022-07-21T08:05:00+08:00
hero: 
draft: false
menu:
  sidebar:
    name: "[K8s] 共享 tnsnames.ora"
    identifier: k8s-example-tnsnames.ora
    parent: container
    weight: 2000
---

## Introduction
Managed ODP.NET 連線資料庫標榜不需要額外安裝 Oracle Clien，資料庫連線資訊可以透過：
- 程式內直接設定 connection string。
- 解析環境變數 TNS_ADMIN 所指資料夾下的 tnsnames.ora。

考慮到可維護性，一旦連線資訊有所變動(Ip/Domain/Port/Service Name/SID)，如果直接將連線字串寫在程式裡面，就需要重新佈署每個程式專案，
因此如果讓 Managed ODP.NET 讀取共用的設定就能夠擁有只維護一份連線資訊的方便性。

單主機的做法是部屬 tnsnames.ora 檔案，但因為 K8S 中 pod 都是隔離的環境，要共用連線資訊透過研究可能有這幾種方式：
1. **ExternalName Service** 對應外部的資料庫位址，無法因應 ip, service name, sid 修改。
2. **Service + Endpoints** 轉送 ip 和 port。
3. **Secret Volume** 共用 tnsnames.ora。

三種連線資訊共用策略是否能反映連線資訊修改：
|                 | ExternalName Service | Service + Endpoints | Secret Volume |
|-----------------|----------------------|---------------------|---------------|
|Ip/Domain        | 可                   | 可                  | 可            | 
|Port             | 不能                 | 可                   |可            |  
|Service Name/SID | 不能                 | 不能                 |可            |  


## Step
Secret 用處： 
 - 作為容器的環境變數 (但只會在 pod 啟動的時候載入，無法反映動態更改)
 - 作為檔案，可被掛載在其他 Pod 的檔案路徑下，此時 key 視為檔案名稱，value 視為檔案內容，可動態反映修改
 - 作為 deployment 的一部分，敏感資料統一存放在 Docker image，讓其他 pod 可以 pull 存取(也無法動態反映修改，要重新 pull)

因此如果要維護 tnsnames.ora，又不需要重啟每個應用程式，必須採取 Secret Volume 共用 tnsnames.ora
P.S. 另外資料庫的使用者帳號、密碼機敏資訊的儲存也可以透過 Secret 提供給 Pod
P.S. 不能是 subPath

### 創建 Secrete
```bash
$ kubectl create secret generic db-secret --from-file=tnsnames.ora
secret/db-secret created

$ kubectl get secret
NAME         TYPE     DATA   AGE
db-secrete   Opaque   1      14s
```
### deployment.yaml

```yaml
apiVersion : apps/v1
kind : Deployment
metadata : 
  name : testap-deployment
spec : 
  selector : 
    matchLabels : 
      app : testap
  replicas :  1
  template : 
    metadata : 
      labels : 
        app : testap
    spec : 
      containers : 
      - name : testap
        image : testap
        ports : 
        - containerPort :  80
        imagePullPolicy: Never
        env:
        - name: TZ
          value: Asia/Taipei
        - name: TNS_ADMIN
          value: /etc/oracle
        volumeMounts:
        - name: tnsora
          mountPath: "/etc/oracle"
          readOnly: true
      volumes:
      - name: tnsora
        secret:
          secretName: db-secrete
          optional: false # default setting; "mysecret" must exist

---

apiVersion: v1
kind: Service
metadata:
  name: testap-service
spec:
  type: ClusterIP
  selector:
    app: testap
  ports:
  - protocol: TCP
    port: 80    
    targetPort: 80  

```
### AP code
```c#
var datasource = "";
var userid = "";
var password = "";
var cnstr = $"Data Source={datasource};;USER ID={userid};PASSWORD={password};;";
using (var cn = new OracleConnection(cnstr)) {
    opname = cn.QueryFirstOrDefault<string>("select 1 from dual");
}
```
```bash
kubectl apply -f testap.yml
minikube kubectl -- expose deployment testap-deployment --type=NodePort --port=80
minikube kubectl -- port-forward testap-deployment-66797fd85b-gx64z 8080:80
```
這時可以打開 http://{k8s ip}:8080 看
## Reference
- [ithome - [Day 12] 敏感的資料怎麼存在k8s?! - Secrets](https://ithelp.ithome.com.tw/articles/10195094)
- [kubernetes - Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [kubernetes - Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
- [Oracle - Oracle Data Provider for .NET Core Configuration](https://docs.oracle.com/en/database/oracle/oracle-database/21/odpnt/InstallCoreConfiguration.html)
- [Oracle tnsnames.ora Distribution Management System!](https://ahmedfattah.com/2017/04/28/oracle-tnsnames-ora-distribution-management-system/)