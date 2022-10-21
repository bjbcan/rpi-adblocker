#!/bin/bash

IP_ADDRESS=192.168.1.67
ROUTER=192.168.1.1
NEW_HOSTNAME=pi3eth1815
SSID=bb_SES_2G
PSK=e6ef4e9f566f0dacbfc39f7eaa6bb20ab13cc4650580f0e1c60fe7ba888a26e7

set +e

CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
# if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
#    /usr/lib/raspberrypi-sys-mods/imager_custom set_hostname raspberrypi
# else
#    echo raspberrypi >/etc/hostname
#    sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\traspberrypi/g" /etc/hosts
# fi

echo $NEW_HOSTNAME >/etc/hostname
sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts
###

FIRSTUSER=`getent passwd 1000 | cut -d: -f1`
FIRSTUSERHOME=`getent passwd 1000 | cut -d: -f6`
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom enable_ssh
else
   systemctl enable ssh
fi
if [ -f /usr/lib/userconf-pi/userconf ]; then
   /usr/lib/userconf-pi/userconf 'pi' '$5$WboLUKN8Cl$OKqRPDSsmnRxu2250Ao1hAsr.b00Qx24NxnNP9A39N/'
else
   echo "$FIRSTUSER:"'$5$WboLUKN8Cl$OKqRPDSsmnRxu2250Ao1hAsr.b00Qx24NxnNP9A39N/' | chpasswd -e
   if [ "$FIRSTUSER" != "pi" ]; then
      usermod -l "pi" "$FIRSTUSER"
      usermod -m -d "/home/pi" "pi"
      groupmod -n "pi" "$FIRSTUSER"
      if grep -q "^autologin-user=" /etc/lightdm/lightdm.conf ; then
         sed /etc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/autologin-user=pi/"
      fi
      if [ -f /etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
         sed /etc/systemd/system/getty@tty1.service.d/autologin.conf -i -e "s/$FIRSTUSER/pi/"
      fi
      if [ -f /etc/sudoers.d/010_pi-nopasswd ]; then
         sed -i "s/^$FIRSTUSER /pi /" /etc/sudoers.d/010_pi-nopasswd
      fi
   fi
fi

# setup dhcpcd.conf
cat >/etc/dhcpcd.conf <<'DHCPDEOF'
interface wlan0
static ip_address=192.168.1.67/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1

#interface eth0
#static ip_address=192.168.1.67/24
#static routers=192.168.1.1
#static domain_name_servers=192.168.1.1

DHCPDEOF
chmod 600 /etc/dhcpcd.conf
#sed here to setup ip address properly

# setup wifi
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_wlan 'bb_SES_2G' 'e6ef4e9f566f0dacbfc39f7eaa6bb20ab13cc4650580f0e1c60fe7ba888a26e7' 'CA'
else
cat >/etc/wpa_supplicant/wpa_supplicant.conf <<'WPAEOF'
country=CA
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
ap_scan=1

update_config=1
network={
	ssid=bb_SES_2G
	psk=e6ef4e9f566f0dacbfc39f7eaa6bb20ab13cc4650580f0e1c60fe7ba888a26e7
}

WPAEOF
# could sed replace a SSID and PSK here
   chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf
   rfkill unblock wifi
   for filename in /var/lib/systemd/rfkill/*:wlan ; do
       echo 0 > $filename
   done
fi
# move the file instead of delete
mv /boot/firstrun.sh /boot/firstrun.sh.done
# copy before delete
cp /boot/cmdline.txt /boot/cmdline.txt.done
sed -i 's| systemd.run.*||g' /boot/cmdline.txt
exit 0
