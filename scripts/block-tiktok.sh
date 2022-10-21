#!/bin/bash
#
# block-tiktok.sh
#
echo 'blocking tiktokgram...'
export PATH="$PATH:/usr/bin:/usr/local/bin/"
sqlite3 /etc/pihole/gravity.db "update adlist set enabled = true where id = 3;"
pihole restartdns
logger pihole: blocking Tiktok
