#!/bin/bash
#
# block-domain.sh 
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"

# installed domain ids
WHOLEWEB=1
GAMING=2
SOCIAL=3
STREAMING=4

piholeupdate () {
    echo sqlite3 /etc/pihole/gravity.db "update domainlist set enabled = $block where id = $domain;"
    sqlite3 /etc/pihole/gravity.db "update domainlist set enabled = $block where id = $domain;"
    echo pihole restartdns
    pihole restartdns
    if [[ $1 = "true" ]]; then
        echo 'blocking domain ${domainlist}...'
        logger pihole: blocking ${domainlist}
    else
        echo 'unblocking domain ${domainlist}...'
        logger pihole: unblocking ${domainlist} 
    fi
}

domain=$2  #should error check this later

if [[ $1  = "-b" ]]; then # block
    block=true
    piholeupdate $block $domainlist
elif [[ $1 = "-u" ]]; then # unblock
    block=false 
    piholeupdate $block $domainlist
else
    echo "Usage: %s (-b|-u) <DOMAINLIST_ID> to block or unblock"
    echo " WHOLEWEB={$WHOLEWEB} \nGAMING=${GAMING} \nSOCIAL=${SOCIAL} \nSTREAMING=${STREAMING}"
fi
