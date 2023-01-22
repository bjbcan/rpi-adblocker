#!/bin/bash

# install lighttpd external.conf
install -v -d			            "${ROOTFS_DIR}/etc/lighttpd"
install -v -m 644 files/external.conf		"${ROOTFS_DIR}/etc/lighttpd/"

# unattended pihole install
install -v -d                                   "${ROOTFS_DIR}/etc/pihole"
install -v -m 644 files/setupVars.conf          "${ROOTFS_DIR}/etc/pihole/"
#install -v -m 644 files/adlists.list            "${ROOTFS_DIR}/etc/pihole/"
install -v -m 655 files/install-adlists.sh          "${ROOTFS_DIR}/etc/pihole/"
install -v -m 655 files/install-domainlists.sh          "${ROOTFS_DIR}/etc/pihole/"
install -v -m 655 files/install-groups.sh          "${ROOTFS_DIR}/etc/pihole/"
install -v -m 777 files/block-adlist.sh          "${ROOTFS_DIR}/home/pi/"
install -v -m 777 files/block-domainlist.sh          "${ROOTFS_DIR}/home/pi/"

export MYVAR=brad_var_passed

on_chroot << EOF
echo "====$$$MYVAR#####==="
echo ${MYVAR}
echo "====$$$#####==="

# clean previous install
echo "Before cleanup ..." 
ls /etc/pihole/
rm -rf /etc/pihole/gravity* /etc/pihole/migration_backup
echo "After cleanup ..." 
ls /etc/pihole/

wget -O basic-install.sh https://install.pi-hole.net

# change script to prefer the armv6/7/8 binaries
sed -i 's/funcOutput=\$(get_binary_name)/funcOutput=\"pihole-FTL-armv6-linux-gnueabihf\"/g w /dev/stdout' basic-install.sh

PIHOLE_SKIP_OS_CHECK=true bash basic-install.sh --unattended

echo "--- what is in the gravity db adlist? ---"
sqlite3 /etc/pihole/gravity.db "select * from adlist;"
echo "--- what is in the gravity db domainlists? ---"
sqlite3 /etc/pihole/gravity.db "select * from domainlist;"

ls /etc/pihole/

# install the regex domain lists
ls -al /etc/pihole/gravity.db
chmod a+w /etc/pihole/gravity.db
bash /etc/pihole/install-domainlists.sh
bash /etc/pihole/install-adlists.sh
bash /etc/pihole/install-groups.sh

echo "--- what is in the gravity db adlist? ---"
sqlite3 /etc/pihole/gravity.db "select * from adlist;"
echo "--- what is in the gravity db domainlist? ---"
sqlite3 /etc/pihole/gravity.db "select * from domainlist;"

# need to run pihole -g or gravity.sh ?
/usr/local/bin/pihole -g

# turn it off so the drive can be unmounted
ps aux | grep -i pihole
killall -r pihole
rm -rf /var/run/pihole/FTL.sock
ps aux | grep -i pihole


EOF

