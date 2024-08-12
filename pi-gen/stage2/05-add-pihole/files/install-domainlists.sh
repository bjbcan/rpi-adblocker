#!/bin/bash
#
# install domainlists pihole
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"

#domainlists=(streaming_video)
domainlists=(all social gaming streaming_video youtube)
all="(.*)"
gaming="(\.|^)nintendo\.com$|(\.|^)nintendo\.net$|(\.|^)roblox\.com$|(\.|^)rbxcdn\.com$|(\.|^)crazygames\.com$|(\.|^)poki\.com$|(\.|^)tracker\.gg$|(\.|^)gamepix\.com$|(\.|^)shellshockers\.net$|(\.|^)nintendo\.net$|(\.|^)playstation\.net$"
social="(\.|^)snapchat\.com$|(\.|^)sc-cdn\.net$|(\.|^)sc-cdn\.net$|(\.|^)t.co$|(\.|^)twitter\.com$|(\.|^)twttr\.com$|(\.|^)reddit\.com$|(\.|^)redd.it$|(\.|^)whatsapp\.com$|(\.|^)discordapp\.com$|(\.|^)signal\.org$"
streaming_video="(\.|^)netflix\.com$|(\.|^)netflix\.ca$|(\.|^)netflix\.net$|(\.|^)dssott\.com$|(\.|^)disneyplus\.com$|(\.|^)disney-plus\.net$|(\.|^)primevideo\.com$|(\.|^)amazonvideo\.com$"
youtube="(\.|^)youtube\.com$|(\.|^)googlevideo\.com$|(\.|^)googleapis\.com$"

for domainlist in ${domainlists[@]} ; do
    echo "adding domainlist $domainlist/${!domainlist} to gravity.db"
    sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist (type, domain, enabled, comment) VALUES (3, '${!domainlist}', 0, '${domainlist}');"
done

