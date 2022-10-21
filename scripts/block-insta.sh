#!/bin/bash
#
# block-insta.sh 
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"
adlist=2

piholeupdate () {
    echo sqlite3 /etc/pihole/gravity.db "update adlist set enabled = $block where id = $adlist;"
    echo pihole restartdns
    if [[ $1 = "true" ]]; then
        echo 'blocking instagram...'
        logger pihole: blocking insta 
    else
        echo 'unblocking instagram...'
        logger pihole: unblocking instaface 
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

