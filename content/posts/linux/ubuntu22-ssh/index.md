---
title: "[Linux] Ubuntu SSH 連線"
date: 2022-11-15T10:23:18+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[Ubuntu] SSH 連線"
    identifier: linux-ubuntu224-ssh
    parent: linux
    weight: 1000
---
## 更改 port
可以直接修改`/etc/ssh/sshd_config`裡面的 Port 設定(解開註解修改)，或直接新增一個檔案：
```bash
sudo echo "Port 22" >> /etc/ssh/sshd_config.d/port.conf
```
重啟 sshd
```bash
service sshd restart
```