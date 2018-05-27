## Important Notice:

I do not take responsibility for anything, including but not limited to:
Violating operator laws, bricking your modem, your local laws, any harm
or loss caused by using the provided script. Read the GPL license provided
with the script.


## The original issue with the modem, TL;DR

ZTE modem operates terribly in IPv6 mode (aka, it sucks beyong your
imagination).  Even if you disable IPv6 mode in connecting devices, it still
sucks. You can disable IPv6 on the modem using the provided script.

Disabling IPv6 on the modem, ping time (of an (almost) near servers) is reduced
from 120~170ms to 50~55ms. Connection are not dropped anymore. And many many
other issues are simply resolved.

The script is automation of some telnet commands. It requires that you install
`expect` and `telnet` on your machine.


## TODO

1. Create an script *on the modem itself*, and perhaps run it periodlically.
some scripts that are writable and are ran on boot, may be modified to achieve
this

2. Totally kill and destroy and abolish the tr069 service running on the modem.
:middle_finger

## ============================ Further Details ================================

My modem is originally locked by the operator (MTN-Irancell). I don't know if
there is a problem with the operator handling IPv6 or the modem itself. In
anycase, it works just fine using IPv4 only.

The printed version on back of my modem is Irancell-MF810, there are no signs of
ZTE anywhere. Looking at the source code of admin page, you can see ZTE
copyright phrase commented out. A text file `/etc/version` says the modem
version (ZTE/zx297520) a little birdy said it is same as MF903 (I googled
actually).

### Is it possible to unlock the modem?

Probably, flashing an unlocked firmware should do it. I don't know if the binary
firmware is available anywhere but there is a link to ZTE-Opensource, and it
contains source code for compiling firmware of some of their modems. Today I
looked again, there was no such thing anymore. At least for MF903.

## ===================== Technical Details Or, Let Me In =======================

credentials: root:*anything* OR admin:admin<br>
command: `telnet 192.168.1.1 4719 -ladmin`

`ladmin` option **MUST** be provided otherwise telnet will just hang or wont
login.<br>
If telnet fails, use nc (netcat) but it's not as good connecting to telnetd.

### You may find these things interesting:

- It runs [uclinux](http://www.uclinux.org/), The Embedded Linux/Microcontroller
  Project.

- Bonus tip: the easiest way to transfer files from modem 

- Fun fact: you can control LED's on the device, go to `/sys/class/leds`
  and echo 0 or 1 to 'bat_red/brightness' or any other led.

- Does it come with GPIO? yes. But I don't know what do they control and where
  is the pinout. Also there are i2c, many uart and... Find them in `/sys/class`

- A goahead server is running on port 80, it's a single binary, HTTP POST/GET
  is handled by some binary, the binary was in `/mnt/jffs2` I guess. Maybe
  `/etc_ro/cgi-bin/upload.cgi`. I don't know if it is possible to find out
  how to unlock the modem using this file.

- You will find many scripts in `/mnt/jffs2/scripts/zte_get_LanEnable.sh`
  I have added a few of my own. The directory is writable.

- A program called `nv` configures the modem. It's a binary.
```
~ # nv
usage: cfg [get name] [set name=value] [unset name] [show] [erase] [save] [restore]
``` 

- Parts of `/etc/rc` file
```
mount -t jffs2 mtd:jffs2 /mnt/jffs2
mount -t jffs2 mtd:yaffs /mnt/yaffs
#mount -t jffs2 mtd:fotaupdate /cache
...
#start adbd
adbd &
```
Dont know what adbd is, it's not on the $PATH (and this is not an android).

- `netstat -tulpn`
```
tcp        0      0 0.0.0.0:4719            0.0.0.0:*               LISTEN      1449/telnetd
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      942/goahead
tcp        0      0 0.0.0.0:53              0.0.0.0:*               LISTEN      19874/dnsmasq
tcp        0      0 :::53                   :::*                    LISTEN      19874/dnsmasq
udp        0      0 0.0.0.0:53              0.0.0.0:*                           19874/dnsmasq
udp        0      0 0.0.0.0:67              0.0.0.0:*                           921/udhcpd
udp        0      0 0.0.0.0:44103           0.0.0.0:*                           19874/dnsmasq
udp        0      0 0.0.0.0:1464            0.0.0.0:*                           19874/dnsmasq
udp        0      0 :::53                   :::*                                19874/dnsmasq
``` 

- `mount`
```
rootfs on / type rootfs (rw)
mtd:userdata on / type romfs (ro,relatime)
proc on /proc type proc (rw,relatime)
sysfs on /sys type sysfs (rw,relatime)
nodev on /sys/kernel/debug type debugfs (rw,relatime)
mtd:jffs2 on /mnt/jffs2 type jffs2 (rw,relatime)
mtd:yaffs on /mnt/yaffs type jffs2 (rw,relatime)
mtd:jffs2 on /tmp type jffs2 (rw,relatime)
mtd:jffs2 on /var type jffs2 (rw,relatime)
mtd:jffs2 on /usr type jffs2 (rw,relatime)
mtd:jffs2 on /usr/bin type jffs2 (rw,relatime)
devpts on /dev/pts type devpts (rw,relatime,mode=600)
mtd:fotaupdate on /cache type jffs2 (rw,relatime)
```

- `ps aux | grep -v '\['` interesting processes only:
```
    1 root       0:01 /sbin/init
  921 root       0:00 udhcpd -f /mnt/jffs2/etc/udhcpd.conf
  936 root       0:00 pc_server # This gives internet access by USB, I guess.
  937 root       0:03 /bin/rtc-service
  942 root       0:02 goahead
  949 root       0:49 fluxstat
  978 root       0:00 pc_server
 1474 root       0:00 /bin/zte_topsw_nvconfig
 1476 root       0:00 /bin/zte_fota_vd
 1670 root       0:00 /bin/rtc-service
13922 root       0:00 lc_mc
17344 root       0:00 zte_ndp -a -s br0 -d ps1 -l /mnt/jffs2/etc/ndp_ps1.log
19874 root       0:00 dnsmasq -i br0 -r /mnt/jffs2/etc/resolv.conf
24694 root       0:00 /bin/webs -x
```

- Busybox (`busybox1 --help`)
```
BusyBox v1.21.0-uc0 (2017-03-06 21:33:53 CST) multi-call binary.
BusyBox is copyrighted by many authors between 1998-2012.
REST OF OUTPUT OMMITED
```

- Model, as found by google search:
  - MF903

- ZTE model (as advertised by /etc/version):
  - ZTE/zx297520 Version 4.0 --  Mon Mar 6 21:40:11 CST 2017

- Resources (you wont find much):
  - [ZET OpenSource, found commented out in admin page](http://opensource.ztedevice.com)
  - [OpenSource Notice](http://download.ztedevices.com/device/global/support/opensource/mobilehotspot/notice/MF903_Open_Source_Software_Notice.pdf)

