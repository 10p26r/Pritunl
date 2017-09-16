#!/bin/bash

# Install Pritunl
sudo tee -a /etc/apt/sources.list.d/mongodb-org-3.4.list << EOF
deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse
EOF

sudo tee -a /etc/apt/sources.list.d/pritunl.list << EOF
deb http://repo.pritunl.com/stable/apt xenial main
EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 0C49F3730359A14518585931BC711F9BA15703C6
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get update
sudo apt-get --assume-yes install pritunl mongodb-org
sudo systemctl start pritunl mongod
sudo systemctl enable pritunl mongod

# Enable Firewall
sudo apt-get -y install ufw
sudo ufw allow 22,80,81,222,443,8080,9700,60000/tcp
sudo ufw allow 22,80,81,222,443,8080,9700,60000/udp
sudo yes | ufw enable

# Change to Time GMT+8
sudo ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# Install Squid Proxy
sudo apt-get install squid apache2-utils -y
sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.orig
sudo wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/10p26r/Pritunl/master/squid.conf"
echo ""
echo "Please wait restart Squid...."
sudo service squid restart
cd
echo "Pritunl and Squid Proxy ..Install Complete"
echo "Source by MNM AMI"
echo ""
echo "Squid Proxy IP : $MYIP Port 3128"
echo "Pritunl : https://$MYIP"
echo "Copy Key and Pless to Pritunl"
pritunl setup-key
echo ""
