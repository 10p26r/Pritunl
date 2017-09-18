#!/bin/bash

myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;
cd

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
cd

# Fail2ban & Exim & Protection
apt-get -y install fail2ban sysv-rc-conf dnsutils dsniff zip unzip;
wget https://github.com/jgmdev/ddos-deflate/archive/master.zip;unzip master.zip;
cd ddos-deflate-master && ./install.sh
service exim4 stop;sysv-rc-conf exim4 off;
cd

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

# Dropbear
apt-get -y install dropbear
wget -O /etc/default/dropbear "https://raw.githubusercontent.com/10p26r/Pritunl/master/Extra/dropbear"
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
cd

# OpenVPN
apt-get -y install openvpn
cd /etc/openvpn/
wget https://raw.githubusercontent.com/zero9911/a/master/script/openvpn/openvpn.tar;tar xf openvpn.tar;rm openvpn.tar
wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/zero9911/a/master/script/openvpn/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i "s/ipserver/$myip/g" /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules
# etc
wget -O /home/vps/public_html/client.ovpn "https://raw.githubusercontent.com/zero9911/a/master/script/openvpn/client.ovpn"
sed -i "s/ipserver/$myip/g" /home/vps/public_html/client.ovpn
cd;wget https://raw.githubusercontent.com/zero9911/a/master/script/openvpn/cronjob.tar
tar xf cronjob.tar;mv uptime.php /home/vps/public_html/
mv usertol userssh uservpn /usr/bin/;mv cronvpn cronssh /etc/cron.d/
chmod +x /usr/bin/usertol;chmod +x /usr/bin/userssh;chmod +x /usr/bin/uservpn;
echo "UPDATE AND INSTALL COMPLETE COMPLETE 99% BE PATIENT"
rm $0;rm *.txt;rm *.tar;rm *.deb;rm *.asc;rm *.zip;rm ddos*;
cd

# restart service
service ssh restart
service dropbear restart
service openvpn restart
service squid restart

clear
echo "

Install Complete.......
"
