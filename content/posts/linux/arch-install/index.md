---
title: "[Arch] 安裝(Virtualbox)"
date: 2023-01-19T11:09:00+08:00
draft: true
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
```
pacstrap -K /mnt base linux linux-firmware vim dhcpcd
```
## fstab
```
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
在`/etc/locale-gen`裡面把`en_US.UTF-8 UTF-8`、`zh_TW.UTF-8 UTF-8`解除註解。
```
locale-gen
```
```
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```
## Network configuration
```
touch /etc/hostname
```
## Root password
```
passwd
```
## Boot loader
```bash
pacman -S grub
# don’t put the disk number sda1, just the disk name sda
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```
## dhcp
```
systemctl enable dhcpd
systemctl start dhcpd
```
## sudo user...
useradd -m naxo
usermod -aG wheel naxo
https://ostechnix.com/add-delete-and-grant-sudo-privileges-to-users-in-arch-linux/
## openssh
pacman -S openssh
systemctl enable sshd
systemctl start sshd
## Reference
- [Arch-Installation_guide](https://wiki.archlinux.org/title/Installation_guide)
https://itsfoss.com/install-arch-linux/