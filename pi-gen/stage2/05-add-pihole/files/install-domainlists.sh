#!/bin/bash
#
# install domainlists pihole
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"


# (1 2 3 4 5 6 7 8)
domainlists=(all social gaming streaming_video youtube facebookinsta tiktok all2 all3 all4 samsung)
all="(.*)"
all2="(.*)|(.*)"
all3="(.*)|(.*)|(.*)"
all4="(.*)|(.*)|(.*)|(.*)"
gaming="nintendo|nintendo|roblox|rbxcdn|crazygames"
gaming+="|poki|trackergamepix|shellshockers|nintendo|playstation"
gaming+="|brawlstars|brawlstarsgame|supercell|exitgames"
gaming+="|supercell|clashroyale|baseballbros|raidfield|geometrydash"
social="snapchat|sc-cdn|scdnsc|twitter|twttr|^x\.com|discordapp|signal|gossiphubdaily"

streaming_video="netflix|nflxvideo|nflxso|dssott|disneyplus"
streaming_video+="|disney-plus|primevideo|amazonvideo|twitchttvnw|jtvnw|ttvnw"
streaming_video+="|minerva\.devices|aiv\-delivery|amazon\.pv\-cdn|prime\-video\.amazon"
youtube="youtube|googlevideo"
facebookinsta="facebook|fbcdn|cdninstagram|instagram|threads"
tiktok="tiktok|tiktokv|tiktokcdn"
samsung="samsung|blacknut|antstream|alibixby|ueiwsp"


for domainlist in ${domainlists[@]} ; do
    echo "adding domainlist $domainlist/${!domainlist} to gravity.db"
    sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist (type, domain, enabled, comment) VALUES (3, '${!domainlist}', 0, '${domainlist}');"
done

echo "adding pihole allow to domainlist gravity.db"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist (type, domain, enabled, comment) VALUES (0, 'pihole', 1, 'pihole local domain');"

