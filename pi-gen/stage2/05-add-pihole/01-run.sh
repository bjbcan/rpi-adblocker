#!/bin/bash

# install lighttpd external.conf
install -v -d					"${ROOTFS_DIR}/etc/lighttpd"
install -v -m 644 files/external.conf		"${ROOTFS_DIR}/etc/lighttpd/"

# unattended pihole install
install -v -d                                   "${ROOTFS_DIR}/etc/pihole"
install -v -m 644 files/setupVars.conf          "${ROOTFS_DIR}/etc/pihole/"

on_chroot << EOF
wget -O basic-install.sh https://install.pi-hole.net
sudo PIHOLE_SKIP_OS_CHECK=true bash basic-install.sh --unattended

EOF

# add pihole adlists

