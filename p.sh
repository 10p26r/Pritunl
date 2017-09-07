#!/bin/bash

# go to root
cd

# Install Command
apt-get -y install ufw
apt-get -y install sudo

# Enable Firewall
sudo ufw allow 22,80,81,222,443,8080,9700,60000/tcp
sudo ufw allow 22,80,81,222,443,8080,9700,60000/udp
sudo yes | ufw enable

# Change to Time GMT+8
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# Install Web Server
apt-get -y install nginx php5-fpm php5-cli
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/zero9911/pritunl/master/conf/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by MKSSHVPN </pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/zero9911/pritunl/master/conf/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# Install Vnstat
apt-get -y install vnstat
vnstat -u -i eth0
sudo chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart

# Install Vnstat GUI
cd /home/vps/public_html/
wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# About
clear
echo ""
echo "Pritunl, Squid3 Proxy, Web Server, Vnstat, Vnstat GUI, Firewall .... Install Success ...."
echo "Debian 8 Jessie"
echo "Source by Mnm Ami"
echo ""
echo "Vnstat GUI : http://$MYIP:81/vnstat"
echo "Pritunl : https://$MYIP"
echo "Copy Key and Pless to Pritunl"
pritunl setup-key
echo ""
