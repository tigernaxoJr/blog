---
title: "[Linux] Ubuntu 20.4 以 netplan 設定網路靜態IP"
date: 2020-06-13T09:37:18+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[Ubuntu] 設定網路靜態IP"
    identifier: linux-ubuntu204-static-ip
    parent: linux
    weight: 1000
---
Ubuntu 自 17.10 以後就可以用 netplan 設置網卡~
# 檢查網路介面
以 ip a 可以看到我的 ubuntu 有2個網路介面分別是 lo、enp0s3，對應到 loopback、有線網卡
```
$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:6a:7b:e3 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 86159sec preferred_lft 86159sec
    inet6 fe80::a00:27ff:fe6a:7be3/64 scope link 
       valid_lft forever preferred_lft forever
```
# 檢查設定檔
所有放置於 /etc/netplan 底下的 yaml 檔都會影響 netplan 的設置，檢查設定檔看到只有一個 00-installer-config.yaml，內容空空如也，一般來說在安裝系統時有設定過網路就會有，如果沒有的話就自己新增囉：
```
# 查看設定檔
$ ls /etc/netplan/
00-installer-config.yaml
$ cat 00-installer-config.yaml 
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp0s3:
      dhcp4: true
  version: 2
```
# 手動配置設定檔
配置特定網卡的方法就是在 YAML 內將配置寫入，如下：
```
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp0s3:  # 網卡名稱
      addresses: [10.0.2.15/24]  # 靜態IP、遮罩
      gateway4: 10.0.2.1  # IPV4 Getway ip
      nameservers:
        addresses: [8.8.8.8,8.8.4.4] # DNS server ip，若有多個就以逗號分隔
      dhcp4: no # 關閉 dhcp 自動取得 IP
    # 如果有 Host only 的話通常都是 enp0s8
    enp0s8:
      addresses: [192.168.56.101/24]  # 靜態IP、遮罩
      routes:
      - to: 192.168.56.1/24
        via: 192.168.56.1
        metric: 100
      #gateway4: 192.168.56.1  # IPV4 Getway ip
      #nameservers:
      #addresses: [8.8.8.8,8.8.4.4] # DNS server ip，若有多個就以逗號分隔
      dhcp4: no # 關閉 dhcp 自動取得 IP
      dhcp6: no # 關閉 dhcp 自動取得 IP
version: 2
```
# 測試設定檔
遠端工作時如果套用了錯誤的網路設定檔就 GG 了，因此在套用之前可以先用 netplan try 測試測定檔是否設置正確，如果沒有在120秒之內進行確認（例如套用了錯誤的網路設定導致使用者斷線）就會回復至先前有效的設定，讓使用者可以再次連上機器修正配置：
```
$ sudo netplan try
Warning: Stopping systemd-networkd.service, but it can still be activated by:
systemd-networkd.socket
Do you want to keep these settings?
Press ENTER before the timeout to accept the new configuration
Changes will revert in 120 seconds
Configuration accepted.
$
```
# 應用設定檔
測試無誤後就可以直接讓設定檔生效了：
```
$ sudo netplan apply
```
現在 ip 已經被固定為 14 囉
```
$ ip a 
1: lo: mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
inet 127.0.0.1/8 scope host lo
valid_lft forever preferred_lft forever
inet6 ::1/128 scope host
valid_lft forever preferred_lft forever
2: enp0s3: mtu 1500 qdisc fq_codel state UP group default qlen 1000
link/ether 08:00:27:6a:7b:e3 brd ff:ff:ff:ff:ff:ff
inet 10.0.2.14/24 brd 10.0.2.255 scope global enp0s3
valid_lft forever preferred_lft forever
inet6 fe80::a00:27ff:fe6a:7be3/64 scope link
valid_lft forever preferred_lft forever
```