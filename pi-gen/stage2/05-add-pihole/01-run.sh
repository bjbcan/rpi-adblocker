#!/bin/bash

on_chroot << EOF
# clean previous install
ls /etc/pihole/
rm -rf /etc/pihole/* /etc/.pihole/*
ls /etc/pihole/
EOF

# install lighttpd external.conf
install -v -d					            "${ROOTFS_DIR}/etc/lighttpd"
install -v -m 644 files/external.conf		"${ROOTFS_DIR}/etc/lighttpd/"

# unattended pihole install
install -v -d                                   "${ROOTFS_DIR}/etc/pihole"
install -v -m 644 files/setupVars.conf          "${ROOTFS_DIR}/etc/pihole/"
install -v -m 644 files/adlists.list            "${ROOTFS_DIR}/etc/pihole/"
install -v -m 655 files/install-adlists.sh          "${ROOTFS_DIR}/etc/pihole/"
install -v -m 655 files/install-regex.sh          "${ROOTFS_DIR}/etc/pihole/"
install -v -m 777 files/block-adlist.sh          "${ROOTFS_DIR}/home/pi/"

on_chroot << EOF
# clean previous install
# ls /etc/pihole/
# rm -rf /etc/pihole/gravity* /etc/pihole/migration_backup
# ls /etc/pihole/

wget -O basic-install.sh https://install.pi-hole.net

# change script to prefer the armv6/7/8 binaries
sed -i 's/funcOutput=\$(get_binary_name)/funcOutput=\"pihole-FTL-armv6-linux-gnueabihf\"/g w /dev/stdout' basic-install.sh

#echo "--- what is in the gravity db adlist? ---"
#sqlite3 /etc/pihole/gravity.db "select * from adlist;"
#echo "--- what is in the gravity db domainlist? ---"
#sqlite3 /etc/pihole/gravity.db "select * from domainlist;"

# the install should pick up from the custom.list file
sudo PIHOLE_SKIP_OS_CHECK=true bash basic-install.sh --unattended

ls /etc/pihole/

# install the regex domain lists
ls -al /etc/pihole/gravity.db
chmod a+w /etc/pihole/gravity.db
sudo bash /etc/pihole/install-regex.sh
sudo bash /etc/pihole/install-adlists.sh

echo "--- what is in the gravity db adlist? ---"
sqlite3 /etc/pihole/gravity.db "select * from adlist;"
echo "--- what is in the gravity db domainlist? ---"
sqlite3 /etc/pihole/gravity.db "select * from domainlist;"

# need to run pihole -g or gravity.sh ?
sudo /usr/local/bin/pihole -g

EOF

