---
title: "[台灣杉] 一鍵登入國網中心台灣杉(Taiwania)"
date: 2019-01-23T09:37:18+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[工具] 一鍵登入台灣杉"
    identifier: other-taiwania-oneclick-login
    parent: other
    weight: 1000
---
台灣杉(Taiwania)是國網中心2018年啟用的超級電腦，登入時密碼必須附加OTP (One-time Password)，國網中心建議取得OTP的方式是從驗證器取得OTP密碼，但這樣的方式每次都需要打開驗證器(手機、chrome插件… etc)，並且需要手動輸入OTP，下面分享我從Windows以及Linux環境下登入台灣杉所使用的一鍵登入方式。

OTP的演算法可粗分為HOTP (HMAC-based OTP)；以及基於HOTP的TOTP (Time-based OTP)，我們不必瞭解演算法細節，只需知道台灣杉採用Base32編碼作為TOTP金鑰(Secret)，時間間格為30秒，每30秒可以根據”Secret”與”當前時間區間”以sha1演算法生成一次性密碼(OTP，或稱為Key)，由於這是單向加密的過程所以無法用時間區間與Key逆推Secret，並且OTP在成功使用一次之後就會被伺服器廢棄，以確保安全性。

# 注意事項
- **校時**  
  由於TOTP演算法依據當前時間區間產生OTP，如果作業系統的時間不正確則會產生錯誤的OTP，在Windows環境之下可以到國家時間與頻率標準實驗室的網頁下載NTP校時軟體，以管理員身分執行進行校時；Linux環境可以用下述指令更新時間並寫入BIOS：
  ```bash
  # 從NTP時間伺服器進行網路校時
  sudo ntpdate time.stdtime.gov.tw
  # 將更新的時間寫入BIOS
  sudo hwclock -w
  ```
- **所有登入行為之間必須間隔30秒(包含使用winSCP、putty或從Linux直接登入)。**
  每個30秒區間會產生一個OTP，而該OTP一旦經過使用就會被伺服器廢棄而無法再用。我曾經連續登入以為程式壞了，但核對iService上面產生的密碼又是一樣的，後來才發現這件事…中間還因為連登失敗太頻繁還被鎖，因此記得間隔30秒以上再登入。
- **Linux要登入台灣衫需要將台灣衫加入know host**，以生醫節點為例:
  ```bash
  ssh-keyscan 140.110.148.14 1>>~/.ssh/known_hosts 2>/dev/null
  ```

# 從Windows登入台灣杉
## 前置工作

- 安裝[Go](https://golang.org/dl/)，並[設置GOPATH](https://github.com/golang/go/wiki/SettingGOPATH)。
- 安裝[putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)。
- 安裝[WinSCP](https://winscp.net/eng/download.php)。
- 知道怎麼打開windows的命令提示字元 (WIN+R、鍵入cmd、enter)。

## 編譯TOTP產生器
取得TOTP套件
```bat
go get github.com/pquerna/otp/totp
```
撰寫程式碼main.go
```go
package main

import (
        "fmt"
        "github.com/pquerna/otp/totp"
        "os"
        "time"
)

func main() {
        secret := os.Args[1]
        code, _ := totp.GenerateCode(secret, time.Now().UTC())
        fmt.Print(code)
}
```
編譯
```bat
go build -o taiwaniaOTP.exe main.go
```
## 設置putty

按照圖片步驟設置putty session，如果不想修改預設字型可跳過步驟4~6，全部設置完成後要回Session標籤按Save(步驟7、8)
![設置Putty Session](set-putty-session.jpg)

## 撰寫批次檔 (串聯TOTP產生器與putty session)

建立資料夾(例如: D:\BioPkg\taiwania)，把剛剛的taiwaniaOTP.exe丟進去，在資料夾內複製下面指令建立taiwania-putty.bat批次檔，按照步驟1~3進行設置：
``` bat
@echo off
:: 1.設置putty執行檔位置
SET putty=D:\Programs\putty.exe
:: 2.設置固定密碼(取代password)
SET regular_pw=password
:: 3.設置TOTP金鑰(從iservice服務網複製的金鑰取代TOTPsecret)
SET secret=TOTPsecret

:: 取得totp
for /f %%i in ('%cd%/taiwaniaOTP.exe %secret%') do set totp=%%i

:: 5.把taiwania-14取代成你剛剛設置的session name
start D:\Programs\putty.exe -load "taiwania-14" -pw %regular_pw%%totp%
exit
```

## 撰寫批次檔 (串聯TOTP產生器與WinSCP)

在資料夾內複製下面指令建立taiwania-sftp.bat，按照步驟1~4設置：
```bat
@echo off
:: 1.設置WinSCP執行檔位置
SET winSCP="C:\Program Files (x86)\WinSCP\WinSCP.exe"
:: 2.設置使用者名稱(取代userName)
SET user=userName
:: 3.設置固定密碼(取代password)
SET regular_pw=password
:: 4.設置TOTP金鑰(從iservice服務網複製的金鑰取代TOTPsecret)
SET secret=TOTPsecret

:: 取得totp
for /f %%i in ('%cd%/taiwaniaOTP.exe %secret%') do set totp=%%i

:: 呼叫winSCP登入台灣杉資料傳輸專用節點
start %winSCP% sftp://%user%:%regular_pw%%totp%@140.110.148.21:22
exit
```

## 測試

目前為止我們完成了兩件事，接下來我們一分鐘的安全間隔進行測試，你可以在桌面上建立批次檔的捷徑方便登入，甚至是改icon讓它們更像一回事：
- 雙擊taiwania-putty.bat呼叫putty session登入台灣杉生醫節點(140.110.148.14)。
- 雙擊taiwania-sftp.bat呼叫winSCP登入台灣杉的資料傳輸節點(140.110.148.21)。

# 從Linux(具有管理員權限)登入台灣杉
使用Linux的設定自動登入需要熟悉基本Linux操作(套件安裝、環境變數、shell script)，或是嘗試按照下列步驟設定，當然您也可以自行編譯上述的OTP產生器(從Windows登入小節所提到)取代oathtool：

## 安裝oathtool、sshpass

```shell
# 如果系統為Red Hat/CentOs/Fedora則改用yum
sudo apt-get update
sudo apt-get install oathtool sshpass
```

## 設置腳本loginTaiwania.sh
```shell
##### loginTaiwania.sh #####
#!/bin/bash
secret="Enter-Your-Otp-Secret-Got-From-Nchc"
taiwaniaIP="140.110.148.14"
userName="Enter-Your-Id-On-Taiwania"
fixedPW="Enter-Your-Fixed-Password"
otp=$(oathtool -b -d6 -s30 --totp="sha1" ${secret})
sshpass -p ${fixedPW}${otp} ssh ${userName}@${taiwaniaIP}
```

## 予登入腳本執行權限
``` shell
chmod a+x loginTaiwania.sh
```

## 測試登入
``` shell
./loginTaiwania.sh
```

# 從Linux(沒有管理員權限)登入台灣杉
有時候會用使用其他機器登入台灣杉，但是卻沒有管理員權限可以安裝sshpass、oathtool，以下是變通方法。

## 確認sshpass、oathtool
查詢系統是否提供sshpass、oathtool，如果已有可以省略編譯的步驟，下面在台灣杉上查詢的結果顯示PATH中有sshpass但找不到oathtool，所以在台灣杉上可以跳過編譯sshpass的步驟。
```shell
$ which sshpass
/usr/bin/sshpass
$ which oathtool
/usr/bin/which: no oathtool in (/home/ux/xxx/bin:/home/xxx/bin:/cm/local/apps/gcc/6.3.0/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/sbin:/cm/local/apps/environment-modules/3.2.10/bin:/opt/pbs/bin:/usr/bin:/usr/bin:/home/xxx/.local/bin:/home/xxx/bin)
```

## 編譯sshpass
最後sshpass的可執行檔預期是/path/to/sshpass-1.06/sshpass。
```
$ wget http://sourceforge.net/projects/sshpass/files/latest/download -O sshpass.tgz
$ tar zxf sshpass.tgz
$ cd sshpass-1.06
$ ./configure && make
$ /path/to/sshpass-1.06/sshpass
Usage: sshpass [-f|-d|-p|-e] [-hV] command parameters
   -f filename   Take password to use from file
   -d number     Use number as file descriptor for getting password
   -p password   Provide password as argument (security unwise)
   -e            Password is passed as env-var "SSHPASS"
   With no parameters - password will be taken from stdin

   -P prompt     Which string should sshpass search for to detect a password prompt
   -v            Be verbose about what you're doing
   -h            Show help (this screen)
   -V            Print version information
At most one of -f, -d, -p or -e should be used
```

## 編譯OTP產生器(oathtool替代方案)
要在像台灣杉類似的主機上編譯oathtool有點複雜，如果一定要用oathtool比較可行的方法是下載binary及so(參考附錄)，但最簡單的方法還是直接編譯自己的OTP產生器，這一步需要先安裝[Go](https://golang.org/dl/)，並及設置[GOPATH](https://github.com/golang/go/wiki/SettingGOPATH)：
```
go get github.com/pquerna/otp/totp
```
撰寫TOTP產生器 main.go
```go
package main

import (
        "fmt"
        "github.com/pquerna/otp/totp"
        "os"
        "time"
)

func main() {
        secret := os.Args[1]
        code, _ := totp.GenerateCode(secret, time.Now().UTC())
        fmt.Print(code)
}
```
編譯TOTP產生器
```
go build -o taiwaniaOTP main.go
```

## 設置腳本loginTaiwania.sh。
```bash
#!/bin/bash
secret="Enter-Your-Otp-Secret-Got-From-Nchc"
taiwaniaIP="140.110.148.14"
userName="Enter-Your-Id-On-Taiwania"
fixedPW="Enter-Your-Fixed-Password"
# 如果系統本身有提供oathtool，就把taiwaniaOTP改成oathtool
otp=$(taiwaniaOTP ${secret})
sshpass -p ${fixedPW}${otp} ssh ${userName}@${taiwaniaIP}
```
## 測試登入
```shell
 ./loginTaiwania.sh
 ```

# 附錄：在沒有權限的主機上使用oathtool (練習抽取package、滿足相依性)
如果要在沒有權限的主機上使用oathtool，就得要自己下載rpm/deb，從裡面抽取binaries及Requires，下面分成rpm(RedHat/CentOS/Fedora)跟apt(Debian/Ubuntu)系統說明：

## rpm(RedHat/CentOS/Fedora)系統
查詢OS版本資訊，得知台灣衫的OS是Red Hat 7.3。
```
$ lsb_release -d
Description:    Red Hat Enterprise Linux Server release 7.3 (Maipo)
```
到[pkgs.org](https://pkgs.org/download)找相應的Binary Package rpm版本，我們點選CentOS 7的EPEL x86_64版本oathtool-2.4.1-9.el7.x86_64.rpm ( CentOS與Red Hat是相容的，EPEL代表Extra Packages for Enterprise Linux，rpm套件管理員當中描述的x86_64是指cpu的x86-64架構，雖然有伺服器已經開始採用較省電的ARM架構，但目前幾乎所有的伺服器架構都是x86-64 )，接著在Download底下取得Binary Package的下載連結，以下面的指令下載、展開、確認相依性：
```
# 下載Binary Package
$ wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/o/oathtool-2.4.1-9.el7.x86_64.rpm
# 抽取Binary Package
$ rpm2cpio oathtool-2.4.1-9.el7.x86_64.rpm | cpio -ivd
./usr/bin/oathtool
./usr/share/doc/oathtool-2.4.1
./usr/share/doc/oathtool-2.4.1/COPYING
./usr/share/man/man1/oathtool.1.gz
165 blocks
# 查看oathtool相依性，not found標註代表相依性未滿足
$ ldd ./usr/bin/oathtool
        linux-vdso.so.1 =>  (0x00002aaaaaaab000)
        liboath.so.0 => not found
        libc.so.6 => /lib64/libc.so.6 (0x00002aaaaaad4000)
        /lib64/ld-linux-x86-64.so.2 (0x0000555555554000)
```
下載oathtool未滿足的相依性，可以直接到剛剛取得下載連結的下載頁面，從Requires欄位下直接點選項目liboath.so.0()(64bit)的連結，一樣選擇CentOS 7的EPEL x86_64版本下載
```
# 下載Binary Package
$ wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/l/liboath-2.4.1-9.el7.x86_64.rpm
# 抽取Binary Package
$ rpm2cpio liboath-2.4.1-9.el7.x86_64.rpm | cpio -ivd
./etc/liboath
./usr/lib64/liboath.so.0
./usr/lib64/liboath.so.0.1.3
./usr/share/doc/liboath-2.4.1
./usr/share/doc/liboath-2.4.1/COPYING
# 查看liboath.so.0相依性，可看到皆滿足
$ ldd ./usr/lib64/liboath.so.0
        linux-vdso.so.1 =>  (0x00002aaaaaaab000)
        libc.so.6 => /lib64/libc.so.6 (0x00002aaaaacdf000)
        /lib64/ld-linux-x86-64.so.2 (0x0000555555554000)
```
到這一步oathtool仍然找不到liboath.so.0，我們也無法把liboath.so.0所在的資料夾加入/etc/ld.so.conf的定義，所以我們要定義一個oathtool.sh腳本，腳本會自動新增LD_LIBRARY_PATH，告訴oathtool要去哪裡找我們剛剛下載的liboath.so.0：
```bash
##### oathtool.sh #####
#!/bin/bash
oathtool="/path/to/oathtool"
ldPath=$(dirname $(readlink -f ${oathtool}))"/../lib64"
export LD_LIBRARY_PATH_OLD=${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH="${ldPath}:${LD_LIBRARY_PATH}"
${oathtool} $@
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH_OLD}
```
現在oathtool.sh表現得就跟oathtool一樣了，以下測試：
```
$ ./oathtool.sh
oathtool 2.4.1

Generate and validate OATH one-time passwords.

Usage: oathtool [OPTIONS]... [KEY [OTP]]...

  -h, --help                    Print help and exit
  -V, --version                 Print version and exit
      --hotp                    use event-based HOTP mode  (default=on)
      --totp                    use time-variant TOTP mode  (default=off)
  -b, --base32                  use base32 encoding of KEY instead of hex
                                  (default=off)
  -c, --counter=COUNTER         HOTP counter value
  -s, --time-step-size=DURATION TOTP time-step duration  (default=`30s')
  -S, --start-time=TIME         when to start counting time steps for TOTP
                                  (default=`1970-01-01 00:00:00 UTC')
  -N, --now=TIME                use this time as current time for TOTP
                                  (default=`now')
  -d, --digits=DIGITS           number of digits in one-time password
  -w, --window=WIDTH            window of counter values to test when
                                  validating OTPs
  -v, --verbose                 explain what is being done  (default=off)

Report bugs to: oath-toolkit-help@nongnu.org
oathtool home page: 
General help using GNU software: 
```

## apt(Debian/Ubuntu)系統
查詢作業系統版本
```
$ lsb_release -d
Description:    Ubuntu 18.04.1 LTS
```
到[pkgs.org](https://pkgs.org/download)找相應的Binary Package apt版本，我們點選Ubuntu 18.04 LTS (Bionic Beaver)的Ubuntu Universe amd64版本oathtool_2.6.1-1_amd64.deb ( BSD Linux家族把x86-64架構稱為AMD64，目前幾乎所有的伺服器架構都是x86_64 )，接著在Download底下取得Binary Package的下載連結，以下面的指令下載、展開、確認相依性：
```
# 先下載oathtool
$ wget http://archive.ubuntu.com/ubuntu/pool/universe/o/oath-toolkit/oathtool_2.6.1-1_amd64.deb
# 抽取oathtool到特定資料夾oathtool內
$ dpkg -X oathtool_2.6.1-1_amd64.deb ./oathtool
./
./usr/
./usr/share/
./usr/share/doc/
./usr/share/doc/oathtool/
./usr/share/doc/oathtool/copyright
./usr/share/man/
./usr/share/man/man1/
./usr/share/man/man1/oathtool.1.gz
./usr/bin/
./usr/bin/oathtool
./usr/share/doc/oathtool/AUTHORS
./usr/share/doc/oathtool/README
./usr/share/doc/oathtool/NEWS.gz
./usr/share/doc/oathtool/changelog.Debian.gz
# 查看oathtool相依性
$ ldd ./oath/usr/bin/oathtool
        linux-vdso.so.1 (0x00007fff10bfe000)
        liboath.so.0 => not found
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fda6c3ea000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fda6c7db000)
# 取得、抽取未滿足的相依性libc.so.6
$ wget http://archive.ubuntu.com/ubuntu/pool/universe/o/oath-toolkit/liboath0_2.6.1-1_amd64.deb
$ dpkg -X liboath0_2.6.1-1_amd64.deb ./oathtool
./
./usr/
./usr/share/
./usr/share/doc/
./usr/share/doc/liboath0/
./usr/share/doc/liboath0/AUTHORS
./usr/share/doc/liboath0/README
./usr/share/doc/liboath0/copyright
./usr/share/doc/liboath0/NEWS.gz
./usr/share/doc/liboath0/changelog.Debian.gz
./usr/lib/
./usr/lib/liboath.so.0.1.3
./usr/lib/liboath.so.0
# 檢查libc.so.6是否滿足
$ ldd ./oath/usr/lib/liboath.so.0
        linux-vdso.so.1 (0x00007ffc0f0f5000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f8f6da78000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f8f6e07d000)
```
到這一步oathtool仍然找不到libc.so.6，我們也無法把libc.so.6所在的資料夾加入/etc/ld.so.conf的定義，所以我們要定義一個oathtool.sh腳本，腳本會自動新增LD_LIBRARY_PATH，告訴oathtool要去哪裡找我們剛剛下載的libc.so.6：
```bash
##### oathtool.sh #####
#!/bin/bash
oathtool="/path/to/oathtool"
ldPath=$(dirname $(readlink -f ${oathtool}))"/../lib"
export LD_LIBRARY_PATH_OLD=${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH="${ldPath}:${LD_LIBRARY_PATH}"
${oathtool} $@
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH_OLD}
```
現在oathtool.sh表現得就跟oathtool一樣了，以下測試：
```
$ ./oathtool/usr/bin/oathtool.sh
oathtool 2.6.1

Generate and validate OATH one-time passwords.

Usage: oathtool [OPTIONS]... [KEY [OTP]]...

  -h, --help                    Print help and exit
  -V, --version                 Print version and exit
      --hotp                    use event-based HOTP mode  (default=on)
      --totp[=STRING]           use time-variant TOTP mode  (possible
                                  values="sha1", "sha256", "sha512"
                                  default=`sha1')
  -b, --base32                  use base32 encoding of KEY instead of hex
                                  (default=off)
  -c, --counter=COUNTER         HOTP counter value
  -s, --time-step-size=DURATION TOTP time-step duration  (default=`30s')
  -S, --start-time=TIME         when to start counting time steps for TOTP
                                  (default=`1970-01-01 00:00:00 UTC')
  -N, --now=TIME                use this time as current time for TOTP
                                  (default=`now')
  -d, --digits=DIGITS           number of digits in one-time password
  -w, --window=WIDTH            window of counter values to test when
                                  validating OTPs
  -v, --verbose                 explain what is being done  (default=off)

Report bugs to: oath-toolkit-help@nongnu.org
oathtool home page: 
General help using GNU software: 
```