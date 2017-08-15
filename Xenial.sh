#!/bin/bash

# Go to Root
cd

# Install Command
apt-get -y install ufw
apt-get -y install sudo

# Install Pritunl
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list
echo "deb http://repo.pritunl.com/stable/apt xenial main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 0C49F3730359A14518585931BC711F9BA15703C6
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get -y update
apt-get --assume-yes install pritunl mongodb-org
systemctl start pritunl mongod
systemctl enable pritunl mongod

# Install Squid Proxy
apt-get -y install squid3
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/zero9911/pritunl/master/conf/squid.conf" 
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart

# Enable Firewall
sudo ufw allow 22,80,81,222,443,8080,9700,60000/tcp
sudo ufw allow 22,80,81,222,443,8080,9700,60000/udp
sudo yes | ufw enable

# Change to Time Zone
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# About
clear
echo ""
echo "Pritunl, Squid Proxy, Firewall .... Install Success ...."
echo "Ubuntu 16.04 Xenial"
echo "Source by Mnm Ami"
echo ""
echo "Copy URL and Pless on Browser : https://$MYIP"
echo "Copy Code and Pless to Pritunl"
pritunl setup-key
echo ""
echo ""
