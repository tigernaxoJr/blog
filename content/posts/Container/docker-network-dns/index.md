---
title: "[Docker] Docker DNS"
date: 2022-04-25T06:26:00+08:00
hero: 
draft: true
menu:
  sidebar:
    name: "[Basic] Docker DNS 服務"
    identifier: container-docker-network-dns
    parent: container
    weight: 2000
---
Linux 把主機名稱對應的 ip 位址儲存在 /etc/hostname
/proc/sys/kernel/hostname 指令
Linux 透過一些機制把 domain name 轉換為 IP 位址
/etc/nsswitch.conf
/etc/hosts
DNS 
## Refrence
 - [Running a DNS server in docker](https://medium.com/nagoya-foundation/running-a-dns-server-in-docker-61cc2003e899)
 - [Debian - Setting the Hostname and Configuring the Name Service](https://debian-handbook.info/browse/stable/sect.hostname-name-service.html)