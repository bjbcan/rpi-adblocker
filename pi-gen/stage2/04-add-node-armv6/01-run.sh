#!/bin/bash

on_chroot << EOF
wget -O - https://unofficial-builds.nodejs.org/download/release/v19.1.0/node-v19.1.0-linux-armv6l.tar.gz | tar xz
rm -rf node-v19.1.0-linux-armv6l.tar.gz
cp -R node-v19.1.0-linux-armv6l/* /usr/local
rm -rf node-v19.1.0-linux-armv6l
node -v
npm -v
npm install -g crontab-ui

#export NVM_DIR="/home/pi/.nvm"

#mkdir -vp ${NVM_DIR}
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
#echo "installed nvm to ${NVM_DIR}"
#ls ${NVM_DIR}
#[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh" 
#NVM_NODEJS_ORG_MIRROR=https://unofficial-builds.nodejs.org/download/release nvm install 19
#chown -R pi:pi ${NVM_DIR}
#echo "for root: npm is found at `which npm`"
#sudo -u pi echo "for pi: npm is found at `which npm`"
#sudo -u pi NVM_DIR="${ROOTFS_DIR}/home/pi/.nvm" npm install -g crontab-ui
#sudo -u pi NVM_DIR="/home/pi/.nvm" npm install -g crontab-ui
EOF
