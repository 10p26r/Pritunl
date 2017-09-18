#!/bin/bash

myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

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
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/squid.conf"
sed -i "s/ipserver/$myip/g" /etc/squid/squid.conf
cd

# MENU
wget https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/menu
wget https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/user-list
wget https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/status
wget https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/monssh
mv menu /usr/local/bin/
mv user-list /usr/local/bin/
mv status /usr/local/bin/
mv monssh /usr/local/bin/
chmod +x  /usr/local/bin/menu
chmod +x  /usr/local/bin/user-list
chmod +x  /usr/local/bin/status
chmod +x  /usr/local/bin/monssh
cd

apt-get -y install dropbear
wget -O /etc/default/dropbear "https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/dropbear"
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
cd

# restart service
service ssh restart
service dropbear restart
service squid restart

clear
echo "

Install Complete.......
"
