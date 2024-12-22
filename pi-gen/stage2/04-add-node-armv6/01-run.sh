#!/bin/bash

export NODEV7URL=https://unofficial-builds.nodejs.org/download/release/v19.4.0/node-v19.4.0-linux-armv7l.tar.gz
export NODEV6URL=https://unofficial-builds.nodejs.org/download/release/v19.4.0/node-v19.4.0-linux-armv6l.tar.gz

on_chroot << EOF

NODEURL=$NODEV6URL    
# if [[  ( $ARMV == 7 ) || ( $ARMV == 8 ) ]]; then
#     NODEURL=$NODEV7URL
#     echo "=~+~+~ ARMv7 chosen for node.js install"
# else
#     NODEURL=$NODEV6URL
#     echo "=~+~+~ ARMv6 chosen for node.js install"
# fi

echo "=~+~+~ ARMv == ${ARMV} and ${NODEURL} and v6=${NODEV6URL} and v7=${NODEV7URL}"

wget -O - $NODEV7URL | tar xz
rm -rf node-*.tar.gz
cp -R node-*-linux-*/* /usr/local
rm -rf node-*-linux-*
node -v
npm -v
npm install -g crontab-ui

EOF
