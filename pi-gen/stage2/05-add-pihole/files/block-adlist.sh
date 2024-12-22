#!/bin/bash
#
# block-adlist.sh 
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"

# installed adlist ids
adlists=(null null ADULTGAMBLING)
ADULTGAMBLING=2

piholeupdate () {
    echo sqlite3 /etc/pihole/gravity.db "update adlist set enabled = $block where id = $adlist;"
    sqlite3 /etc/pihole/gravity.db "update adlist set enabled = $block where id = $adlist;"
    echo pihole restartdns
    pihole restartdns
    if [[ $1 = "true" ]]; then
        echo "blocking adlist ${adlists[$adlist]} ..."
        logger pihole: blocking ${adlists[$adlist]}
    else
        echo "unblocking adlist ${adlists[$adlist]} ..."
        logger pihole: unblocking ${adlists[$adlist]} 
    fi
}

adlist=$2  #should error check this later

if [[ $1  = "-b" ]]; then # block
    block=true
    piholeupdate $block $adlist
elif [[ $1 = "-u" ]]; then # unblock
    block=false 
    piholeupdate $block $adlist
else
    echo "Usage: %s (-b|-u) <LIST_ID> to block or unblock"
    echo "ADULTGAMBLING=${ADULTGAMBLING}"
fi
