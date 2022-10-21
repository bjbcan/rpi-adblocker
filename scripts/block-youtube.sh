#!/bin/bash
#
# block-youtube.sh
#
echo 'blocking youtube...'
export PATH="$PATH:/usr/bin:/usr/local/bin/"
sqlite3 /etc/pihole/gravity.db "update adlist set enabled = true where id = 4;"
pihole restartdns
logger pihole: blocking youtube
