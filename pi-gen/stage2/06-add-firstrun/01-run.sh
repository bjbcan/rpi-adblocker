#!/bin/bash

install -v -m 644 files/firstrun.sh		"${ROOTFS_DIR}/boot/firmware/"

on_chroot << EOF

echo "~~~~~ Global IP is ${GLOBAL_IP} ~~~~~~~"

sed -i "s|GLOBAL_IP|$GLOBAL_IP|g" /boot/firmware/firstrun.sh
sed -i "s|WPA_COUNTRY|$WPA_COUNTRY|g" /boot/firmware/firstrun.sh

head -n 15 /boot/firmware/firstrun.sh

EOF


