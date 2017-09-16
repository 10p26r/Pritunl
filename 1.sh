#!/bin/bash

cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/10p26r/Pritunl/master/2.conf"
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
