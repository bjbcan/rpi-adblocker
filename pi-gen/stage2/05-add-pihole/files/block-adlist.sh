#!/bin/bash
#
# block-adlist.sh 
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"

# installed adlist ids
FACESTAGRAM=2
YOUTUBETWITCH=3
TIKTOK=4
ADULTGAMBLING=5

piholeupdate () {
    echo sqlite3 /etc/pihole/gravity.db "update adlist set enabled = $block where id = $adlist;"
    sqlite3 /etc/pihole/gravity.db "update adlist set enabled = $block where id = $adlist;"
    echo pihole restartdns
    pihole restartdns
    if [[ $1 = "true" ]]; then
        echo 'blocking adlist ${adlist}...'
        logger pihole: blocking ${adlist}
    else
        echo 'unblocking adlist ${adlist}...'
        logger pihole: unblocking ${adlist} 
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
    echo " FACESTAGRAM=${FACESTAGRAM}\n YOUTUBETWITCH=${YOUTUBETWITCH} \nTIKTOK=${TIKTOK} \nADULTGAMBLING=${ADULTGAMBLING}"
fi
