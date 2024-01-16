---
title: "[OpenWrt] 在 linux 中使用 Docker 跑 OpenWrt"
date: 2024-01-16T08:46:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[OpenWrt] Docker"
    identifier: other-openwrt-docker
    parent: other
    weight: 1000
---
### 開啟網卡 promisc
```
ip link set enp0s3 promisc on 
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
docker network create -d macvlan \
	--subnet=10.0.2.0/24 \
	--gateway=10.0.2.2 \
	-o parent=enp0s3 mywrt
```
### 製作 OpenWrt 容器
`docker-compose.yml`
```yml
version: '3'
services:
  openwrt:
    image: zzsrv/openwrt:latest
	container_name: openwrt
    restart: always 			# 退出時嘗試重啟容器
    privileged: true 			# 提升權限
    networks:
      - mywrt					# 接入 mywrt 網路
    command: /sbin/init 		# 定義容器啟動後，直接啟動 openwrt

networks:
  mywrt:
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
```bash
vim /etc/config/network
```
lan 的部分改成這樣，dns、getway 改成閘道器、 ipaddr 改成 openwrt 要的 ip：
```
config interface 'lan'
        option proto 'static'
        option netmask '255.255.255.0'
        option ip6assign '60'
        option ipaddr '10.0.2.3'
        option gateway '10.0.2.2'
        option dns '10.0.2.2'
        option device 'br-lan'
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

## Reference
- [在Docker 中运行 OpenWrt 旁路网关](https://mlapp.cn/376.html)
- [DockerHub-zzsrv/openwrt](https://hub.docker.com/r/zzsrv/openwrt)