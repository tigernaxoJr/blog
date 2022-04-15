---
title: "[WebTech] 在 Debain 上安裝基於 LEMP 的 Wordpress"
date: 2020-11-14T21:41:00+08:00
lastmod: 2020-11-14T21:41:00+08:00
draft: true
tags: ["OAuth", "Authentication", "Token"]
categories: ["WebTech"]
author: "tigernaxo"

autoCollapseToc: true
#contentCopyright: '<a rel="license noopener" href="https://en.wikipedia.org/wiki/Wikipedia:Text_of_Creative_Commons_Attribution-ShareAlike_3.0_Unported_License" target="_blank">Creative Commons Attribution-ShareAlike License</a>'
---
# 安裝 Debain10
# 安裝 NGINX
```bash
$ apt-get install nginx
$ systemctl start nginx
$ systemctl enable nginx
$ systemctl status nginx
```
# 安裝 PHP(7.3)、mariaDB
```bash
apt-get install php php-mysql php-fpm php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip mariadb-server mariadb-client
```
確認
```bash
$ systemctl status mariadb
$ systemctl is-enabled mariadb
```
```bash
$ systemctl start php7.3-fpm
$ systemctl enable php7.3-fpm
$ systemctl status php7.3-fpm
```
```bash
mysql_secure_installation
```
Enter current password for root (enter for none): Enter
Set a root password? [Y/n] y
Remove anonymous users? [Y/n] y
Disallow root login remotely? [Y/n] y
Remove test database and access to it? [Y/n] y
Reload privilege tables now? [Y/n] y
```bash
# mysql -u root -p
MariaDB [(none)]> CREATE DATABASE wordpress;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON wordpress.* TO 'username'@'localhost' IDENTIFIED BY  'password';
MariaDB [(none)]> FLUSH PRIVILEGES;
MariaDB [(none)]> EXIT;
```
# 安裝 wordpress
```
$ mkdir -p /var/www/html/wordpress
$ wget http://wordpress.org/latest.tar.gz
$ tar xfvz latest.tar.gz
$ cp -r wordpress/* /var/www/html/wordpress
$ chown -R www-data /var/www/html/wordpress
$ chmod -R 755 /var/www/html/wordpress
```
/etc/nginx/conf.d/wordpress.conf
```
server {
  listen 80;
  listen [::]:80;
  root /var/www/html/wordpress; 
  index index.php index.html index.htm; 
  server_name wordpress www.wordpress; 
  error_log /var/log/nginx/wordpress_error.log; 
  access_log /var/log/nginx/wordpress_access.log; 
  client_max_body_size 100M; 
  location / { 
    try_files $uri $uri/ /index.php?$args; 
    } 
  location ~ \.php$ { 
    include snippets/fastcgi-php.conf; 
    fastcgi_pass unix:/run/php/php7.3-fpm.sock; 
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; 
    } 
  }
```
```
$ rm /etc/nginx/sites-enabled/default
$ rm /etc/nginx/sites-available/default
$ nginx -t
$ systemctl restart nginx
```
http://SERVER_IP/
# reference 
- [How to Install WordPress with Nginx on Debian and Ubuntu](https://www.tecmint.com/install-wordpress-using-nginx-in-ubuntu-debian-mint/)