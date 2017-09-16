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
# sudo apt-get install squid apache2-utils -y
