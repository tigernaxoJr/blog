---
title: "[Docker] Linux-namespace 和 cgroup"
date: 2022-04-25T06:26:00+08:00
hero: 
draft: false
menu:
  sidebar:
    name: "[Basic] Namespace"
    identifier: container-base-resource
    parent: container
    weight: 2000
---
UTS namespace – 隔離 interface, ip address, iptagbles, route 等各式各樣跟網路有關的資源
IPC namespace – 隔離 inter process communication
PID namespace – 程序編號(Process ID)，每個容器都會有PID=1的超級父process，這個process在本機上也會有另一個PID
Network namespace – 允許擁有獨立的網路設備、IP Address、路由、port
Mount namespace – 掛載點，也就是隔離文件系統
User namespace – user及user group
## Reference
- [第 11 屆 iThome 鐵人賽 - [Day4] 淺談 Container 實現原理, 初探 Namespace 隔離](https://ithelp.ithome.com.tw/articles/10217583)
- [Jennifer的Docker筆記本 - Linux Namespace](https://cutejaneii.gitbook.io/docker/docker-underlying-technology/linux-namespaces)
- [DOCKER基础技术：LINUX NAMESPACE（上）](https://coolshell.cn/articles/17010.html)
- [DOCKER基础技术：LINUX NAMESPACE（下）](https://coolshell.cn/articles/17029.html)
- [linux cgroup技術介紹](https://www.twblogs.net/a/5c9bde00bd9eee752388288e)