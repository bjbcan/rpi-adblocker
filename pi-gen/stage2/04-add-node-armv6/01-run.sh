#!/bin/bash

on_chroot << EOF
NODEV7URL=https://builds.nodejs.org/download/release/v19.1.0/node-v19.1.0-linux-armv7l.tar.gz
NODEV6URL=https://unofficial-builds.nodejs.org/download/release/v19.1.0/node-v19.1.0-linux-armv6l.tar.gz

if (($ARMV==7)) || (($ARMV==8)); then
    NODEURL=$NODEV7URL
    echo "=~+~+~ ARMv7 chosen for node.js install"
else
    NODEURL=$NODEV6URL
    echo "=~+~+~ ARMv6 chosen for node.js install"
fi

echo "=~+~+~ ARMv == ${ARMV} and ${NODEURL}"

wget -O - $NODEURL | tar xz
rm -rf node-*.tar.gz
cp -R node-*-linux-*/* /usr/local
rm -rf node-*-linux-*
node -v
npm -v
npm install -g crontab-ui

EOF
