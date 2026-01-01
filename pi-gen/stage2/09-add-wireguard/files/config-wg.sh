#!/bin/bash

echo "~~~~~ original wireguard server config~~~~~~"
cat /etc/wireguard/wg0.conf

# linux command to get eth0 ip address
DNS=$(ip -4 -o addr show eth0 | awk '{print $4}' | cut -d'/' -f1)
SERVER_PRIVATE_KEY=`/usr/bin/wg genkey`
SERVER_PUBLIC_KEY=`echo $SERVER_PRIVATE_KEY | /usr/bin/wg pubkey`
CLIENT_PRIVATE_KEY=`/usr/bin/wg genkey`
CLIENT_PUBLIC_KEY=`echo $CLIENT_PRIVATE_KEY | /usr/bin/wg pubkey`

# set {DNS}, {SERVER_PRIVATE_KEY}, and {CLIENT_PUBLIC_KEY}
sed -i "s|{DNS}|$DNS|" /etc/wireguard/wg0.conf
sed -i "s|{SERVER_PRIVATE_KEY}|$SERVER_PRIVATE_KEY|" /etc/wireguard/wg0.conf
sed -i "s|{CLIENT_PUBLIC_KEY}|$CLIENT_PUBLIC_KEY|" /etc/wireguard/wg0.conf

echo "~~~~~ wireguard server config ~~~~~~"
cat /etc/wireguard/wg0.conf
echo "~~~~~ wireguard client config ~~~~~~"
wg showconf wg0

echo " ~~~ wg CLIENT_PRIVATE_KEY=$CLIENT_PRIVATE_KEY, CLIENT_PUBLIC_KEY=$CLIENT_PUBLIC_KEY"
echo " ~~~ wg SERVER_PRIVATE_KEY=$SERVER_PRIVATE_KEY, SERVER_PUBLIC_KEY=$SERVER_PUBLIC_KEY"

echo "~~~~~ To Run Wireguard Server ~~~~~~"
echo "sudo systemctl start wg-quick@wg0"

echo "~~~~~ To Enable Wireguard Server Service ~~~~~~"
echo "sudo systemctl enable wg-quick@wg0"
