#!/bin/bash

# install rc.local
#install -v -m 644 files/wg0.conf		"${ROOTFS_DIR}/etc/wireguard/"
#install -v -m 755 files/config-wg.sh		"${ROOTFS_DIR}/home/pi/"

on_chroot << EOF

#chown -R pi:pi /home/pi/config-wg.sh


#add tailscale signed repos and update 
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
apt-get update
apt-get install -y tailscale

# start tailscale and capture auth URL
# tailscale up | grep -o 'https://login.tailscale.com/admin/machines/[a-f0-9]*/auth' > /home/pi/tailscale-auth-url.txt

# need to do this after first boot
# sudo tailscale up


EOF


