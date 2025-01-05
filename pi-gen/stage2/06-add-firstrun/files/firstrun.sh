#!/bin/bash

NEW_HOSTNAME=adblocker
# IP_ADDRESS=192.168.1.91
# ROUTER=192.168.1.1
# SSID=
# # if plaintext password, then `-p` arg is required in:
# # /usr/lib/raspberrypi-sys-mods/imager_custom set_wlan -p $SSID $PSK $COUNTRY
# PSK=
# USE_WLAN0=true # default to wlan0, if false then use eth0
COUNTRY=CA
SERIAL=`cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2 | tail -c 5`

set +e

CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_hostname $NEW_HOSTNAME
  touch /boot/brad-imager_used_for_set_hostname
# else #typically not executed
#    echo $NEW_HOSTNAME >/etc/hostname
#    sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts
fi


FIRSTUSER=`getent passwd 1000 | cut -d: -f1`
FIRSTUSERHOME=`getent passwd 1000 | cut -d: -f6`
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom enable_ssh
  touch /boot/brad-imager_used_for_enable_ssh
# else #typically not executed
#    systemctl enable ssh
fi

if [ -f /usr/lib/userconf-pi/userconf ]; then
   /usr/lib/userconf-pi/userconf 'pi' '$5$WboLUKN8Cl$OKqRPDSsmnRxu2250Ao1hAsr.b00Qx24NxnNP9A39N/'
  touch /boot/brad-userconf-pi_used
# else #typically not executed
#    echo "$FIRSTUSER:"'$5$WboLUKN8Cl$OKqRPDSsmnRxu2250Ao1hAsr.b00Qx24NxnNP9A39N/' | chpasswd -e
#    if [ "$FIRSTUSER" != "pi" ]; then
#       usermod -l "pi" "$FIRSTUSER"
#       usermod -m -d "/home/pi" "pi"
#       groupmod -n "pi" "$FIRSTUSER"
#       if grep -q "^autologin-user=" /etc/lightdm/lightdm.conf ; then
#          sed /etc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/autologin-user=pi/"
#       fi
#       if [ -f /etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
#          sed /etc/systemd/system/getty@tty1.service.d/autologin.conf -i -e "s/$FIRSTUSER/pi/"
#       fi
#       if [ -f /etc/sudoers.d/010_pi-nopasswd ]; then
#          sed -i "s/^$FIRSTUSER /pi /" /etc/sudoers.d/010_pi-nopasswd
#       fi
#    fi
fi

# # setup dhcpcd.conf: this *is* used. Use eth0 or wlan0 but not both
# cat >/etc/dhcpcd.conf <<'DHCPDEOF'
# # written by firstrun.sh
# interface wlan0
# static ip_address=IPADDRESS/24
# static routers=ROUTER
# static domain_name_servers=ROUTER
# DHCPDEOF

# #sed here to setup ip address properly
# sed -i "s|IPADDRESS|$IP_ADDRESS|g" /etc/dhcpcd.conf
# sed -i "s|ROUTER|$ROUTER|g" /etc/dhcpcd.conf
# chmod 644 /etc/dhcpcd.conf

# #
# # need to setup pihole and dhcpcd.conf to use eth0 since it is not the default in the image
# #
# if [ $USE_WLAN0 == false ]; then 
#    # change to use eth0 instead of wlan0
#    sed -i "s|wlan0|eth0|g" /etc/pihole/setupVars.conf
#    sed -i "s|wlan0|eth0|g" /etc/dhcpcd.conf
#    echo "# eth0 set from sed" >> /etc/dhcpcd.conf
#    # disable wifi altogether
#    rfkill block wifi 
#    for filename in /var/lib/systemd/rfkill/*:wlan ; do
#        echo 0 > $filename
#    done
# fi   


# # setup wifi
# if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
#    /usr/lib/raspberrypi-sys-mods/imager_custom set_wlan $SSID $PSK $COUNTRY
#    touch /boot/brad-imager_used_for_wlan
# # else #typically not executed
# # cat >/etc/wpa_supplicant/wpa_supplicant.conf <<'WPAEOF'
# # # written by firstrun.sh ${USE_WLAN0}
# # country=CA
# # ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
# # ap_scan=1

# # update_config=1
# # network={
# # 	ssid=SSID
# # 	psk=PSK
# # }

# # WPAEOF
# #    # sed replace a SSID and PSK here
# #    sed -i "s|SSID|$SSID|g" /etc/wpa_supplicant/wpa_supplicant.conf
# #    sed -i "s|PSK|$PSK|g" /etc/wpa_supplicant/wpa_supplicant.conf

# #    chmod 644 /etc/wpa_supplicant/wpa_supplicant.conf
# #    rfkill unblock wifi
# #    for filename in /var/lib/systemd/rfkill/*:wlan ; do
# #        echo 0 > $filename
# #    done
# fi


# set wlan country so that wifi broadcasts correctly
/usr/lib/raspberrypi-sys-mods/imager_custom set_wlan_country $COUNTRY

# enable wifi radio
rfkill unblock wifi
for filename in /var/lib/systemd/rfkill/*:wlan ; do
    echo 0 > $filename
done

# write an interface file for the hotspot
cat >/etc/NetworkManager/system-connections/Hotspot.nmconnection  << HOTSPOTEOF
# written by firstrun.sh
[connection]
id=Hotspot
uuid=d183d1d4-cf03-415e-9311-918d898d988d
type=wifi
interface-name=wlan0

[wifi]
band=bg
mode=ap
ssid=$NEW_HOSTNAME-$SERIAL

[wifi-security]
key-mgmt=wpa-psk
psk=raspberry

[ipv4]
method=shared

[ipv6]
addr-gen-mode=default
method=auto
HOTSPOTEOF
chmod 600 /etc/NetworkManager/system-connections/Hotspot.nmconnection

if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_keymap 'us'
   /usr/lib/raspberrypi-sys-mods/imager_custom set_timezone 'America/Toronto'
else
   rm -f /etc/localtime
   echo "America/Toronto" >/etc/timezone
   dpkg-reconfigure -f noninteractive tzdata
cat >/etc/default/keyboard <<'KBEOF'
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS=""

KBEOF
   dpkg-reconfigure -f noninteractive keyboard-configuration
fi

# move the file instead of delete
mv /boot/firmware/firstrun.sh /boot/firmware/firstrun.sh.done
# copy before change
cp /boot/firmware/cmdline.txt /boot/firmware/cmdline.txt.done
sed -i 's| systemd.run.*||g' /boot/firmware/cmdline.txt
# copy fstab for vol uuid to /boot/fstab
# echo "# `date`" >> /boot/fstab.txt
# grep  'PARTUUID' /etc/fstab | tail -1 | awk '{print $1}' >> /boot/fstab.txt
exit 0
