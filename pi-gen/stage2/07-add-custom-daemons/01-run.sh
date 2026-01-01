#!/bin/bash

# install two systemd services
install -v -m 644 files/pihole_writeable.service		"${ROOTFS_DIR}/lib/systemd/system/"
install -v -m 644 files/pihole_writeable.timer		"${ROOTFS_DIR}/lib/systemd/system/"
install -v -m 644 files/wifi_hotspot_disable.service		"${ROOTFS_DIR}/lib/systemd/system/"
install -v -m 644 files/wifi_hotspot_disable.timer		"${ROOTFS_DIR}/lib/systemd/system/"
install -v -m 644 files/crontabui.service		    "${ROOTFS_DIR}/lib/systemd/system/"
install -v -m 644 files/internet-buttons.service		    "${ROOTFS_DIR}/lib/systemd/system/"
install -v -m 644 files/01-dnsmasq.conf		    "${ROOTFS_DIR}/etc/NetworkManager/dnsmasq-shared.d/"


install -v -d 			                   "${ROOTFS_DIR}/home/pi/crontabui"
install -v -d   			              "${ROOTFS_DIR}/home/pi/crontabui/logs"
install -v -m 644 files/crontab.db           "${ROOTFS_DIR}/home/pi/crontabui/"

install -v -T -m 644 files/nginx.conf      "${ROOTFS_DIR}/etc/nginx/sites-available/default"

on_chroot << EOF

echo "Setting ownership of /home/pi/crontabui to pi:pi"
chown -R pi:pi /home/pi/crontabui

echo "Setting ownership of /home/pi/internet-buttons to pi:pi"
chown -R pi:pi /home/pi/internet-buttons

echo "127.0.0.1 pi.hole" >> /etc/hosts
echo "127.0.0.1 pihole" >> /etc/hosts


EOF
