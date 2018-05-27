#!/usr/bin/bash

function error() {
    echo ""
    echo "ERROR:: $1 is not present in the PATH"
    echo ""
    echo "this script requires both 'telnet' and 'expect' to be present on the PATH"
    echo "you must install it, on debian/ubuntu using apt, fedora: dnf, centos: yum, arch: pacman, mac: i don't know."
    echo ""
    echo "PATH=$PATH"
    exit 1
}

which telnetx 2>/dev/null || error 'telnet'
which expectx 2>/dev/null || error 'expect'

echo 'All ok, you are good to go, run zte_ipv6_fix.sh to fix your modem.'
echo 'Your machine must be connected to the modem, if you have changed the default ip (192.168.1.1) or default username/password (admin:admin) you must modify the script accordingly.'
