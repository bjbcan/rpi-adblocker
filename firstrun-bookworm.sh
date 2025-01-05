#!/bin/bash

set +e

CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_hostname rpi-bookworm-firstrun
else
   echo rpi-bookworm-firstrun >/etc/hostname
   sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\trpi-bookworm-firstrun/g" /etc/hosts
fi
FIRSTUSER=`getent passwd 1000 | cut -d: -f1`
FIRSTUSERHOME=`getent passwd 1000 | cut -d: -f6`
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom enable_ssh -k 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuKZ5CsoCLGOECCw7dzj17cY/6ohidiN4hf344q28SG5d/Q64OkwGoyXxY0FpfnsdytvNwiBPNzGnoN6oXSsL9jWSh8qTKxwh1cN5p5OregrFhjxVll/W0wqNqlCc2czcHrhmDZ2MtTulGNK2ARjmRGAD7tzLL19dzGjcODTBGSS+5SMKiVQgJ3d5WagFH6/iCgV0GdGPrf8etLR2Y3rMo4yNoDDlx0BCLwXqsXEaZb7Xjt50jMV1CKyAtsNUNrU9vzKBz0GpbIispmknVupBqRRVx6mG9A93lyDT2Lz7Kk2RVyStwE8OC8hkeDtlsW1DIk7JcaEN1nCJ83WrLX0M1hPvzIGWuTbCfk4aVVNdsWpt2evKhO+lW2Jh9DLSnAo9G5sQvMReVYPJ84VNxEPZtlLgxxqXLR1r9OwmtReIjccJO4Otmb/1Q/EdqBjgJ2Mz7WvEnZ/MC4OYURSwTd/qNuR1WKYQr6TV+DGehcNVFRY7wtsl5vknh84CLurS/R9s= brad@brad-mbpm1.local'
else
   install -o "$FIRSTUSER" -m 700 -d "$FIRSTUSERHOME/.ssh"
   install -o "$FIRSTUSER" -m 600 <(printf "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuKZ5CsoCLGOECCw7dzj17cY/6ohidiN4hf344q28SG5d/Q64OkwGoyXxY0FpfnsdytvNwiBPNzGnoN6oXSsL9jWSh8qTKxwh1cN5p5OregrFhjxVll/W0wqNqlCc2czcHrhmDZ2MtTulGNK2ARjmRGAD7tzLL19dzGjcODTBGSS+5SMKiVQgJ3d5WagFH6/iCgV0GdGPrf8etLR2Y3rMo4yNoDDlx0BCLwXqsXEaZb7Xjt50jMV1CKyAtsNUNrU9vzKBz0GpbIispmknVupBqRRVx6mG9A93lyDT2Lz7Kk2RVyStwE8OC8hkeDtlsW1DIk7JcaEN1nCJ83WrLX0M1hPvzIGWuTbCfk4aVVNdsWpt2evKhO+lW2Jh9DLSnAo9G5sQvMReVYPJ84VNxEPZtlLgxxqXLR1r9OwmtReIjccJO4Otmb/1Q/EdqBjgJ2Mz7WvEnZ/MC4OYURSwTd/qNuR1WKYQr6TV+DGehcNVFRY7wtsl5vknh84CLurS/R9s= brad@brad-mbpm1.local") "$FIRSTUSERHOME/.ssh/authorized_keys"
   echo 'PasswordAuthentication no' >>/etc/ssh/sshd_config
   systemctl enable ssh
fi
if [ -f /usr/lib/userconf-pi/userconf ]; then
   /usr/lib/userconf-pi/userconf 'pi' '$5$/5Gob4XO69$xs508Qvz.PflXpkjSyqKatLyFN3xVSXnp8xTK2XZeSB'
else
   echo "$FIRSTUSER:"'$5$/5Gob4XO69$xs508Qvz.PflXpkjSyqKatLyFN3xVSXnp8xTK2XZeSB' | chpasswd -e
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
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_wlan 'BELL530' 'a93c94b96098296d6f5d4c5995ddac9a4d09e4c773f144c25bf3359b15fcc05d' 'CA'
else
cat >/etc/wpa_supplicant/wpa_supplicant.conf <<'WPAEOF'
country=CA
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
ap_scan=1

update_config=1
network={
	ssid="BELL530"
	psk=a93c94b96098296d6f5d4c5995ddac9a4d09e4c773f144c25bf3359b15fcc05d
}

WPAEOF
   chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf
   rfkill unblock wifi
   for filename in /var/lib/systemd/rfkill/*:wlan ; do
       echo 0 > $filename
   done
fi
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
rm -f /boot/firstrun.sh
sed -i 's| systemd.run.*||g' /boot/cmdline.txt
exit 0
