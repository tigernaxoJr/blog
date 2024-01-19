---
title: "[OpenWrt] 在 linux 中使用 Docker 跑 OpenWrt"
date: 2024-01-19T08:00:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[OpenWrt] Docker"
    identifier: other-openwrt-docker
    parent: other
    weight: 1000
---

定義一個 Network，叫做 MYNAT，關閉 DHCP。

新增一部虛擬機，定義兩張網卡：
1. 預設 NAT：用來模擬 ISP 裝置。(enp0s3)
2. MYNAT：用來建構內網。(enp0s8)

### 開啟網卡 promisc
```
ip link set enp0s3 promisc on 
ip link set enp0s8 promisc on 
```
###. 建立 docker 網路
查詢路由所在網段、遮罩、閘道器。
```bash
ip route show dev enp0s3
```
結果：軟路由所在網段、遮罩為 `10.0.2.0/24`、閘道器 `10.0.2.2`。
```
default via 10.0.2.2 proto dhcp src 10.0.2.15 metric 1024
10.0.2.0/24 proto kernel scope link src 10.0.2.15 metric 1024
10.0.2.2 proto dhcp scope link src 10.0.2.15 metric 1024
192.73.141.230 via 10.0.2.2 proto dhcp src 10.0.2.15 metric 1024
192.73.144.230 via 10.0.2.2 proto dhcp src 10.0.2.15 metric 1024
```

創建 docker 網路
```bash
#!/bin/bash
docker network rm openwrt-wan
docker network create -d macvlan \
  --subnet=10.0.2.0/24 \
  --gateway=10.0.2.2 \
  -o parent=enp0s3 openwrt-wan

docker network rm openwrt-lan
docker network create -d macvlan \
  --subnet=10.0.3.0/24 \
  --gateway=10.0.3.254 \
  -o parent=enp0s8 openwrt-lan
```

### 製作 OpenWrt 容器
`docker-compose.yml`
```yml
version: '3'
services:
  openwrt:
    image: zzsrv/openwrt:latest
    container_name: openwrt
    restart: always
    privileged: true
    volumes:
      - ./network:/etc/config/network
    networks:
      - openwrt-wan
      - openwrt-lan
    command: /sbin/init

networks:
  openwrt-wan:
    external: true
  openwrt-lan:
    external: true
```
啟動
```bash
docker-compose up -d && docker-compose logs -f
```
設定容器的網路
```bash
docker exec -it openwrt bash
```
`/etc/config/network` 改成這樣：  
```
config interface 'loopback'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'
        option device 'lo'

config globals 'globals'
        option packet_steering '1'

config interface 'lan'
        option proto 'static'
        option ipaddr '10.0.3.254'
        option netmask '255.255.255.0'
        option device 'br-lan'

config interface 'wan'
        option proto 'dhcp'
        option netmask '255.255.255.0'
        option device 'br-wan'

config interface 'utun'
        option proto 'none'
        option ifname 'utun'
        option device 'utun'

config device
        option name 'br-lan'
        option type 'bridge'
        list ports 'eth1'

config device
        option name 'br-wan'
        option type 'bridge'
        list ports 'eth0'
```

重啟網路
```bash
/etc/init.d/network restart
```
### openwrt 設定
目前 openwrt 和路由主機處於同一個 NAT 下了，可以使用剛剛設定給 openwrt 的 IP `http://10.0.2.3` 進入控制面板，如果是用 virtualbox 就自行使用連接埠轉送。
 - 使用者：`root`
 - 密碼：`password`

取消 lan 的 DHCP： 
- `Network` -> `Interfaces` 點選 lan 項目的 `Edit`
- `DHCP Server` -> `General Setup` -> 確認勾選 `Ignore interface` 
### host 設定
主機無法直接透過 ip 訪問 macvlan 底下的 openwrt，需要額外設置一個 route：
這裡使用腳本比較清楚，方便修改：`route.sh`
```bash
#!/bin/bash
device="enp0s8"
macvlan="mac30"
target="10.0.3.254"
macvlan_ip="10.0.3.253"

ip link add link ${device} ${macvlan} type macvlan mode bridge
ip addr add ${macvlan_ip}/24 brd + dev ${macvlan}
ip link set ${macvlan} up
# let host automatically use macvlan when communicating with target
ip route add ${target} dev ${macvlan}
```

執行
```
chmod a+x ./route.sh
./route.sh
```
接下來主機就能使用內網 ip ping 到 openwrt

## Reference
- [在Docker 中运行 OpenWrt 旁路网关](https://mlapp.cn/376.html)
- [DockerHub-zzsrv/openwrt](https://hub.docker.com/r/zzsrv/openwrt)
- [Using Docker macvlan networks](https://blog.oddbit.com/post/2018-03-12-using-docker-macvlan-networks/)