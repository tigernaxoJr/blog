---
title: "[Linux] CentOS 8 設定網路靜態IP"
date: 2020-06-16T09:37:18+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[CentOS] 設定網路靜態IP"
    identifier: linux-centos8-static-ip
    parent: linux
    weight: 1000
---
# 查詢IP
```
$ ip a
1: lo: mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
inet 127.0.0.1/8 scope host lo
valid_lft forever preferred_lft forever
inet6 ::1/128 scope host
valid_lft forever preferred_lft forever
2: enp0s3: mtu 1500 qdisc fq_codel state UP group default qlen 1000
link/ether 08:00:27:85:fe:50 brd ff:ff:ff:ff:ff:ff
inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute enp0s3
valid_lft forever preferred_lft forever
inet6 fe80::98e4:9fbc:ba91:db3f/64 scope link noprefixroute
valid_lft forever preferred_lft forever
```
# 修改網路設定
修改網路介面設置如下，檔案名稱預設為ifcfg-網路介面(網路卡)名稱，舉例來說安裝好 CentOS 預設的網路卡 enp0s3 設定檔：/etc/sysconfig/network-scripts/ifcfg-enp0s3
```toml
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="static"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="enp0s3"
UUID="15114252-a2e9-4fd7-9a2e-c5cc82d0417b"
DEVICE="enp0s3"
ONBOOT="yes"         # 設置開機啟動
IPADDR="10.0.2.101"  # 設置靜態IP位址動
PREFIX="24"          # 子網路遮照，等價於 NETMASK="255.255.255.0"
GATEWAY="10.0.2.1"   # 閘道器位址
DNS1="8.8.8.8"       # DNS1
DNS2="9.9.9.9"       # DNS2
IPV6_PRIVACY="no"
```
# 重啟網路介面
```Shell
# 停用
ifdown enp0s3
# 啟動
ifup enp0s3
```
檢查ip，已變更：
```
$ ip a
1: lo: mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
inet 127.0.0.1/8 scope host lo
valid_lft forever preferred_lft forever
inet6 ::1/128 scope host
valid_lft forever preferred_lft forever
2: enp0s3: mtu 1500 qdisc fq_codel state UP group default qlen 1000
link/ether 08:00:27:85:fe:50 brd ff:ff:ff:ff:ff:ff
inet 10.0.2.101/24 brd 10.0.2.255 scope global noprefixroute enp0s3
valid_lft forever preferred_lft forever
inet6 fe80::98e4:9fbc:ba91:db3f/64 scope link noprefixroute
valid_lft forever preferred_lft forever
```

