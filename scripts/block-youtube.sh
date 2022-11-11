#!/bin/bash
#
# block-youtube.sh 
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"
adlist=4

piholeupdate () {
    echo sqlite3 /etc/pihole/gravity.db "update adlist set enabled = $block where id = $adlist;"
    echo pihole restartdns
    if [[ $1 = "true" ]]; then
        echo 'blocking youtube...'
        logger pihole: blocking youtube 
    else
        echo 'unblocking youtube...'
        logger pihole: unblocking youtubeface 
    fi
}

if [[ $1  = "-b" ]]; then # block
    block=true
    piholeupdate $block $adlist
elif [[ $1 = "-u" ]]; then # unblock
    block=false 
    piholeupdate $block $adlist
else
    echo "Usage: %s (-b|-u) to block or unblock"
fi
