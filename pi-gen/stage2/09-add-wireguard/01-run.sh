#!/bin/bash

# install rc.local
install -v -m 644 files/wg0.conf		"${ROOTFS_DIR}/etc/wireguard/"
install -v -m 755 files/config-wg.sh		"${ROOTFS_DIR}/home/pi/"

on_chroot << EOF

chown -R pi:pi /home/pi/config-wg.sh

EOF


