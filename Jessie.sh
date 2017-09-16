#!/bin/bash

# go to root
cd

# Install Command
apt-get -y install ufw
apt-get -y install sudo

# Install Pritunl
echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" > /etc/apt/sources.list.d/mongodb-org-3.4.list
echo "deb http://repo.pritunl.com/stable/apt jessie main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 0C49F3730359A14518585931BC711F9BA15703C6
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get update
apt-get --assume-yes install pritunl mongodb-org
systemctl start mongod pritunl
systemctl enable mongod pritunl

# Enable Firewall
sudo ufw allow 22,80,81,222,443,8080,9700,60000/tcp
sudo ufw allow 22,80,81,222,443,8080,9700,60000/udp
sudo yes | ufw enable

# Change to Time GMT+8
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# About
clear
echo ""
echo "Pritunl .... Install Success ...."
echo "Debian 8 Jessie"
echo "Source by Mnm Ami"
echo ""
echo "Pritunl : https://$MYIP"
echo "Copy Key and Pless to Pritunl"
pritunl setup-key
echo ""
