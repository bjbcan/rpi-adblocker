#!/bin/bash
#
# install adlist lists pihole
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"

adlists=(adult_gambling)
#facebook_instagram="https://raw.githubusercontent.com/imkarthikk/pihole-facebook/master/pihole-facebook.txt"
#youtube_twitch="https://raw.githubusercontent.com/bjbredis/adlist/main/youtube.hosts"
#tiktok="https://raw.githubusercontent.com/danhorton7/pihole-block-tiktok/main/tiktok.txt"
adult_gambling="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"


for adlist in ${adlists[@]} ; do
    echo "adding adlist ${adlist}/${!adlist} to gravity.db"
    sqlite3 /etc/pihole/gravity.db "insert or ignore into adlist (address, enabled, comment) VALUES ('${!adlist}', 0, '${adlist}');"
done


