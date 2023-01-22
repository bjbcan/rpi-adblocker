#!/bin/bash

# install rc.local
install -v -m 744 files/rc.local		"${ROOTFS_DIR}/etc/"

on_chroot << EOF

echo "+++ contents of /etc/rc.local +++++"
cat /etc/rc.local
echo "+++ contents of /etc/rc.local +++++"


EOF


