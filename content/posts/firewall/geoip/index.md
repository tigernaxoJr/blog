---
title: "[防火牆] 地理位置規則(GeoIP)"
date: 2025-06-03T15:52:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[GeoIP] 封鎖地理位置"
    identifier: firewall-geoip
    parent: firewall
    weight: 100
---
最近在 GCP 上，中南美洲的網路流量讓我每個月多花了好幾十塊...台幣，對免費仔而言實在有點不能接受！其實，我們可以從 IP 層面直接把這些不必要的流量擋掉。
## 為什麼要擋流量？
如果你的網站或服務主要受眾不在中南美洲，那麼來自這些地區的流量很可能是惡意掃描、DDoS 攻擊的嘗試，或是其他你不需要的連線。擋掉這些流量，除了能省下荷包，也能降低主機的負擔，提升安全性。

## 如何實現 IP 層級封鎖？
對於 Linux 主機或虛擬機器 (VM)，最直接、開源且有效的方法就是使用 iptables 或 nftables。這兩者都是 Linux 內建的防火牆工具，可以在 IP 層級進行精準的流量控制。

不過，光有 iptables/nftables 還不夠，我們需要一個方式來識別哪些 IP 屬於中南美洲。這時候就需要搭配：

- xtables-addons (或類似的腳本工具，例如 geoip-shell)：這些工具能讓你根據地理位置來設定防火牆規則。
- MaxMind GeoLite2 資料庫：這是一個免費的地理位置 IP 資料庫，它會告訴你每個 IP 位址來自哪個國家或地區。

## 讓工具自動搞定！
手動去找出中南美洲的所有 IP 範圍，然後一條一條地加到防火牆規則裡，那也太費時了！開源專案 `friendly-bits/geoip-shell` 已經為我們把這項工作簡化了許多。

透過這個專案，可以：
- 自動生成防火牆規則：它會根據 MaxMind GeoLite2 資料庫，自動產生針對特定國家或地區的 IP 封鎖規則。
- 排程自動更新 IP：IP 位址的歸屬可能會變動，geoip-shell 還能設定排程，自動更新 GeoLite2 資料庫和防火牆規則，確保你的封鎖列表始終保持最新。  
這樣一來，就能輕鬆地從 IP 層面阻擋來自中南美洲的流量，有效控制 GCP 的網路費用，同時提升主機的安全性！

```bash
# 安裝 geoip-shell
# 根據其 GitHub 說明進行安裝

# 生成封鎖南美洲的規則
sudo geoip-shell block --countries AR,BO,BR,CL,CO,EC,GF,GY,PY,PE,SR,UY,VE
```