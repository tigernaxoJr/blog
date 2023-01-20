---
title: "[Arch] 安裝(Virtualbox)"
date: 2023-01-20T11:14:30+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[Arch] 安裝(Virtualbox)"
    identifier: arch-install
    parent: linux
    weight: 100
---
## Timezone
```bash
timedatectl set-timezone Asia/Taipei
```
## 分割磁碟
```
fdisk /dev/sda
```
```
mkswap /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
swapon /dev/sda1
```
##
安裝
```bash
pacstrap -K /mnt base linux linux-firmware vim sudo openssh 
```
## fstab
產生 fstab
```bash
# -U Use UUIDs for source identifiers 
genfstab -U /mnt >> /mnt/etc/fstab
```
## Chroot
```
arch-chroot /mnt
```
## Time zone
```bash
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
# generate /etc/adjtime
hwclock --systohc
```
## Localization
在`/etc/locale.gen`裡面把`en_US.UTF-8 UTF-8`、`zh_TW.UTF-8 UTF-8`解除註解。
```
locale-gen
```
```
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```
## Boot loader
```bash
pacman -S grub
# don’t put the disk number sda1, just the disk name sda
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```
## Root password
```
passwd
```
... 然後重開機
## Network configuration
```
touch /etc/hostname
```
使用內建的 systemd-networkd，新增檔案 `/etc/systemd/network/default.network`
```yaml
[Match]
Name=*

[Network]
DHCP=yes
```
```bash
# enable
systemctl enable systemd-networkd
systemctl enable systemd-resolved

# start
systemctl start systemd-networkd
systemctl start systemd-resolved
```
## openssh
```bash
systemctl enable sshd
systemctl start sshd
```
## sudo user...
visudo，讓 %wheel 成為 sudor
useradd -m naxo
usermod -aG wheel naxo
https://ostechnix.com/add-delete-and-grant-sudo-privileges-to-users-in-arch-linux/
## Reference
- [Arch-Installation_guide](https://wiki.archlinux.org/title/Installation_guide)
https://itsfoss.com/install-arch-linux/