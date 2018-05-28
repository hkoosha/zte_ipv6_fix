#!/usr/bin/env expect

puts "Script to disable IPv6 on ZTE modem and de-suck it\nAuthor: Koosha Hosseiny <info@koosha.cc>\n"

set timeout 15
set script /mnt/jffs2/scripts/disable_ipv6.sh
set scripts /mnt/jffs2/scripts

spawn telnet 192.168.1.1 4719 -ladmin

expect "login:"
send "admin\n"

expect "Password:"
send "admin\n"

expect "~ #"
send "echo '#! /bin/sh' > $script \n"
send "echo 'echo disabling IPv6 on all interfaces' >> $script \n"
send "echo 'echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' >> $script \n"
send "chmod +x $script \n"
send "echo 'echo IPv6 disabled on all interfaces' >> $script \n"

send "echo $script >> $scripts/wan_ipv6.sh \n"
send "echo $script >> $scripts/wan_ipv6_config.sh \n"
send "echo $script >> $scripts/usb_up_down.sh \n"
send "echo $script >> $scripts/static_ip_ini.sh \n"
send "echo $script >> $scripts/psext_updown_ipv6.sh \n"
send "echo $script >> $scripts/psext_updown.sh \n"
send "echo $script >> $scripts/landev_updown.sh \n"
send "echo $script >> $scripts/lan.sh \n"
send "echo $script >> $scripts/internet.sh \n"
send "echo $script >> $scripts/global.sh \n"
send "echo $script >> $scripts/eth_updown.sh \n"

send "reboot \n"

interact

