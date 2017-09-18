#!/bin/bash

if [ $USER != 'root' ]; then
	echo "Sorry, for run the script please using root user"
	exit
fi
if [[ ! -e /dev/net/tun ]]; then
	echo "TUN/TAP is not available"
	exit
fi

# SQUID
apt-get -y install squid
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/zero9911/a/master/script/squid.conf"
sed -i "s/ipserver/$myip/g" /etc/squid/squid.conf
cd

# MENU
wget https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/menu
wget https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/user-list
wget https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/monssh
wget https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/status
mv menu /usr/local/bin/
mv user-list /usr/local/bin/
mv monssh /usr/local/bin/
mv status /usr/local/bin/
chmod +x  /usr/local/bin/menu
chmod +x  /usr/local/bin/user-list
chmod +x  /usr/local/bin/monssh
chmod +x  /usr/local/bin/status
cd

# restart service
service ssh restart
service squid restart

clear
echo "

Install Complete.......
"
