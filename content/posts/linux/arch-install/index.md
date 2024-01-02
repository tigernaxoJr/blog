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
## BIOS system
1. 分割磁碟， /dev/sda1 給 1G，其餘給 /dev/sda2
    ```
    fdisk /dev/sda
    ```
    ```
    mkswap /dev/sda1
    mkfs.ext4 /dev/sda2
    mount /dev/sda2 /mnt
    swapon /dev/sda1
    ```
2. 安裝(arch 核心、linux 核心、韌體)
    ```bash
    pacstrap -K /mnt base linux linux-firmware 
    ```
    其他套件(非必要)
    ```bash
    pacstrap -K /mnt vim sudo openssh docker docker-compose bash-completion
    ```
3. 產生 fstab
    ```bash
    # -U Use UUIDs for source identifiers 
    genfstab -U /mnt >> /mnt/etc/fstab
    ```
4. Chroot
    ```
    arch-chroot /mnt
    ```
5. Time zone
    ```bash
    ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
    # generate /etc/adjtime
    hwclock --systohc
    ```
6. Localization
在`/etc/locale.gen`裡面把`en_US.UTF-8 UTF-8`、`zh_TW.UTF-8 UTF-8`解除註解。
    ```
    locale-gen
    ```
    ```
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf
    ```
7. Boot loader
    ```bash
    pacman -S grub
    # don’t put the disk number sda1, just the disk name sda
    grub-install /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
    ```
8. Root password
    ```
    passwd
    ```
9. 重開機
    ```bash
    exit
    unmount -R /mnt
    reboot
    ```
## EFI system
首先在 virtualbox 硬體的部分將 EFI 打勾
1. 分割磁碟，使用 GPT table，/dev/sda1, /dev/sda2 給 1G，其餘給 /dev/sda3
    ```
    fdisk /dev/sda
    ```
    ```
    mkswap /dev/sda1
    mkfs.fat -F32 /dev/sda2
    mkfs.ext4 /dev/sda3
    mount /dev/sda2 /mnt/boot/efi --mkdir
    mount /dev/sda3 /mnt
    swapon /dev/sda1
    ```
2. 安裝(arch 核心、linux 核心、韌體)
    ```bash
    pacstrap -K /mnt base linux linux-firmware 
    ```
    其他套件(非必要)
    ```bash
    pacstrap -K /mnt vim sudo openssh docker docker-compose bash-completion
    ```
3. 產生 fstab
    ```bash
    # -U Use UUIDs for source identifiers 
    genfstab -U /mnt >> /mnt/etc/fstab
    ```
4. Chroot
    ```
    arch-chroot /mnt
    ```
5. Time zone
    ```bash
    ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
    # generate /etc/adjtime
    hwclock --systohc
    ```
6. Localization
    ```
    locale-gen
    ```
    ```
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf
    ```
7. Boot loader
    ```bash
    pacman -S grub efibootmgr os-prober
    grub-install --target=x86_64-efi --bootloader-id=grub --efi-directory=/boot/efi
    grub-mkconfig -o /boot/grub/grub.cfg
    ```
8. Root password
    ```
    passwd
    ```
9. 重開機
    ```bash
    exit
    unmount -R /mnt
    reboot
    ```
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