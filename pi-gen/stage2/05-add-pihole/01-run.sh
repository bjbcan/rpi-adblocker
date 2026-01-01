#!/bin/bash

# install lighttpd external.conf
install -v -d			                    "${ROOTFS_DIR}/etc/lighttpd"
install -v -d			                     "${ROOTFS_DIR}/etc/lighttpd/conf-enabled"
install -v -m 644 files/external.conf		"${ROOTFS_DIR}/etc/lighttpd/conf-enabled/"

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
# echo "====$$$MYVAR#####==="
# echo ${MYVAR}
# echo "====$$$#####==="

# clean previous install
echo "Before cleanup ..." 
ls /etc/pihole/
rm -rf /etc/pihole/gravity* /etc/pihole/migration_backup
echo "After cleanup ..." 
ls /etc/pihole/

wget -O basic-install.sh https://install.pi-hole.net

# change script to prefer the armv6/7/8 binaries
#sed -i 's/funcOutput=\$(get_binary_name)/funcOutput=\"pihole-FTL-armv6-linux-gnueabihf\"/g w /dev/stdout' basic-install.sh
#sed -i 's/funcOutput=\$(get_binary_name)/funcOutput=\"pihole-FTL-armv8-linux-gnueabihf\"/g w /dev/stdout' basic-install.sh

PIHOLE_SKIP_OS_CHECK=true bash basic-install.sh --unattended

# echo "--- what is in the gravity db adlist? ---"
# sqlite3 /etc/pihole/gravity.db "select * from adlist;"
# echo "--- what is in the gravity db domainlists? ---"
# sqlite3 /etc/pihole/gravity.db "select * from domainlist;"

ls /etc/pihole/

# install the regex domain lists
ls -al /etc/pihole/gravity.db
chmod a+w /etc/pihole/gravity.db
bash /etc/pihole/install-domainlists.sh
bash /etc/pihole/install-adlists.sh
bash /etc/pihole/install-groups.sh

# echo "--- what is in the gravity db adlist? ---"
# sqlite3 /etc/pihole/gravity.db "select * from adlist;"
# echo "--- what is in the gravity db domainlist? ---"
# sqlite3 /etc/pihole/gravity.db "select * from domainlist;"

# need to run pihole -g or gravity.sh ?
/usr/local/bin/pihole -g



# add user pi to group pihole so it can run block/unblock adlist/domainlist
echo "----"
adduser pi pihole

# set pihole web UI to no password
# echo -ne '\n' | pihole admin -p

# # get PiHoleController
# echo "Downloading PiHoleController ..."
# curl -q -o /var/www/html/admin/controller.html https://raw.githubusercontent.com/mikeswanson/PiHoleController/main/controller.html

# turn it off so the drive can be unmounted
SERVICE="pihole-FTL"
if pgrep -x "pihole-FTL" >/dev/null
then
    echo "--= ==--- pihole-FTL is running: kill it."
    killall -r pihole-FTL
    rm -rf /var/run/pihole/FTL.sock
else
    echo "--= ==--- pihole-FTL not running"
fi

echo "--= ==--- pihole.toml "
cat /etc/pihole/pihole.toml | grep -B2 -A3 "hosts\ ="
echo "--= ==--- pihole.toml "


EOF

