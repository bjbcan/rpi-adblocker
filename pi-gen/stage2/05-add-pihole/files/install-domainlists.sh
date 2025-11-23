#!/bin/bash
#
# install domainlists pihole
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"


# (1 2 3 4 5 6 7 8)
domainlists=(all social gaming streaming_video youtube facebookinsta tiktok)
all="(.*)"
gaming="nintendo|nintendo|roblox|rbxcdn|crazygames"
gaming+="|poki|trackergamepix|shellshockers|nintendo|playstation"
gaming+="|brawlstars|brawlstarsgame|supercell|exitgames"
gaming+="|supercell|clashroyale|"
social="snapchat|sc-cdn|scdnsc.com|t.co|twitter|twttr|reddit|redd.it|whatsapp|discordapp|signal"

streaming_video="netflix|netflixnetflix|nflxvideo|nflxso|dssott|disneyplus"
streaming_video+="|disney-plus|primevideo|amazonvideo|twitchttvnw|jtvnw|ttvnw"
youtube="youtube|googlevideo"
facebookinsta="facebookcom|fbcdn|cdninstagram|instagram"
tiktok="tiktok|tiktokv|tiktokcdn"
samsung="samsung|blacknut|antstream|alibixby|ueiwsp"


for domainlist in ${domainlists[@]} ; do
    echo "adding domainlist $domainlist/${!domainlist} to gravity.db"
    sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist (type, domain, enabled, comment) VALUES (3, '${!domainlist}', 0, '${domainlist}');"
done

