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

# Install Squid Proxy
apt-get -y install squid3
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/10p26r/Pritunl/master/Squid3.conf"
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart
echo ""
echo "Please wait restart Squid...."
sudo service squid restart
cd

# End
echo "Pritunl and Squid Proxy ..Install Complete"
echo "Source by Mnm Ami"
echo ""
echo "Squid Proxy : $MYIP Port 80, 8000, 8080"
echo "Pritunl : https://$MYIP"
echo "Copy Key and Pless to Pritunl"
pritunl setup-key
echo ""
