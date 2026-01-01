#!/bin/bash

export NODEV7URL=https://nodejs.org/dist/v19.9.0/node-v19.9.0-linux-armv7l.tar.gz
export NODEV6URL=https://unofficial-builds.nodejs.org/download/release/v19.4.0/node-v19.4.0-linux-armv6l.tar.gz

export NODEARM64URL=https://nodejs.org/dist/v19.9.0/node-v19.9.0-linux-arm64.tar.gz
# export NODEARM64URL=https://nodejs.org/dist/latest-v22.x/node-v22.21.1-linux-arm64.tar.gz

install -v -d 			                   "${ROOTFS_DIR}/home/pi"


on_chroot << EOF


wget -O - $NODEARM64URL | tar xz
rm -rf node-*.tar.gz
cp -R node-*-linux-*/* /usr/local
rm -rf node-*-linux-*
node -v
npm -v
# cat /root/.npm/_logs/*

# Install crontab-ui
CI=true npm install -g crontab-ui


echo "Downloading internet-buttons"
cd /home/pi/
# ls -al 
export GIT_TERMINAL_PROMPT=0
# git -v
echo "Cloning internet-buttons"
git clone https://github.com/bjbcan/internet-buttons.git
cd internet-buttons
chown -R pi:pi /home/pi/internet-buttons
echo "Installing internet-buttons"
CI=true npm install



EOF
