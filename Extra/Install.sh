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

ln -fs /usr/share/zoneinfo/Asia/Thailand /etc/localtime;
echo ipv4 >> /etc/modules
echo ipv6 >> /etc/modules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove postfix*;
apt-get -y --purge remove bind*;
clear

# MENU
wget https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/menu
wget https://raw.githubusercontent.com/zero9911/a/master/script/user-list
wget https://raw.githubusercontent.com/zero9911/a/master/script/monssh
wget https://raw.githubusercontent.com/zero9911/a/master/script/status
mv menu /usr/local/bin/
mv user-list /usr/local/bin/
mv monssh /usr/local/bin/
mv status /usr/local/bin/
chmod +x  /usr/local/bin/menu
chmod +x  /usr/local/bin/user-list
chmod +x  /usr/local/bin/monssh
chmod +x  /usr/local/bin/status
cd

# SSH
sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
wget -O /etc/issue.net "https://raw.githubusercontent.com/zero9911/a/master/script/banner"

# DROPBEAR
apt-get -y install dropbear
wget -O /etc/default/dropbear "https://raw.githubusercontent.com/zero9911/a/master/script/dropbear"
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
cd

# SQUID3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/zero9911/a/master/script/squid.conf"
sed -i "s/ipserver/$myip/g" /etc/squid3/squid.conf
cd


# OPENVPN
wget https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/openvpn.sh && chmod +x openvpn.sh && ./openvpn.sh

# restart service
service ssh restart
service openvpn restart
service dropbear restart
service squid3 restart

clear
echo "

Install Complete.......
"
cat /dev/null > ~/.bash_history && history -c
exit
fi
