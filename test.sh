#!/bin/bash

apt-get -y install squid
cp /etc/squid/squid.conf /etc/squid/squid.conf.orig
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/10p26r/Pritunl/master/squid3.conf"
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid/squid.conf;
service squid restart
