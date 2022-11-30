#!/bin/bash
#
# install regex lists pihole
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"

#regexes=(streaming_video)
regexes=(all social gaming streaming_video)
all="(.*)"
gaming="(\.|^)nintendo\.net$|(\.|^)roblox\.com$|(\.|^)rbxcdn\.com$|(\.|^)crazygames\.com$|(\.|^)poki\.com$|(\.|^)tracker\.gg$|(\.|^)gamepix\.com$|(\.|^)shellshockers\.net"
social="(\.|^)snapchat\.com$|(\.|^)sc-cdn\.net$|(\.|^)sc-cdn\.net$|(\.|^)t.co$|(\.|^)titter\.com$|(\.|^)twttr\.com$|(\.|^)reddit\.com$|(\.|^)redd.it$|(\.|^)whatsapp\.com$|(\.|^)discordapp\.com$|(\.|^)signal\.org$"
streaming_video="(\.|^)netflix\.com$|(\.|^)netflix\.ca$|(\.|^)netflix\.net$|(\.|^)dssott\.com$|(\.|^)disneyplus\.com$|(\.|^)disney-plus\.net"

for regex in ${regexes[@]} ; do
    echo "adding regex $regex/${!regex} to gravity.db"
    sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist (type, domain, enabled, comment) VALUES (3, '${!regex}', 0, '${regex}');"
done

