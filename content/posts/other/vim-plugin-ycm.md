---
title: "[Linux] 在 Ubuntu 20.04 中設置 vim plugin YouCompleteMe"
date: 2020-11-18T23:14:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[工具] Vim Plugin YCM"
    identifier: other-vim-plugin-ycm
    parent: other
    weight: 1000
---
# 安裝 junegunn/vim-plug 管理套件
以指令安裝 junegunn/vim-plug
```shell
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
在 ~/.vimrc 加入 Plug 'ycm-core/YouCompleteMe'
```
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'ycm-core/YouCompleteMe'

" Initialize plugin system
call plug#end()
```
打開 vim，在 vim 命令列輸入安裝 Plugin 的指令下載 YCM，這個時候還沒編譯所以會顯示安裝失敗
```
:PlugInstall
```
# 編譯YCM
安裝編譯工具
```shell
sudo apt install -y build-essential cmake vim python3-dev 
```
編譯
```shell
~/.vim/plugged/YouCompleteMe/install.py
```

# 測試
打開 vim 確認，完工~

# Reference 
- [GitHub - ycm-core/YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
- [GitHub - junegunn/vim-plug](https://github.com/junegunn/vim-plug)
