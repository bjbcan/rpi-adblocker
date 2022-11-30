#!/bin/bash
#
# install adlist lists pihole
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"

adlists=(facebook_instagram youtube_twitch tiktok adult_gambling)
facebook_instagram="https://raw.githubusercontent.com/imkarthikk/pihole-facebook/master/pihole-facebook.txt"
youtube_twitch="https://raw.githubusercontent.com/bjbredis/rpi-adblocker/adlists/youtube.hosts"
tiktok="https://raw.githubusercontent.com/gieljnssns/Social-media-Blocklists/master/pihole-tiktok.txt"
adult_gambling="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"

curl -o /dev/null -Isw 'facebook: %{http_code}\n' $facebook_instagram
curl -o /dev/null -Isw 'youtube: %{http_code}\n' $youtube_twitch


for adlist in ${adlists[@]} ; do
    echo "adding adlist ${adlist}/${!adlist} to gravity.db"
    sqlite3 /etc/pihole/gravity.db "insert or ignore into adlist (address, enabled, comment) VALUES ('${!adlist}', 0, '${adlist}');"
done


