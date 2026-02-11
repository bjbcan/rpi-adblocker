#!/bin/bash
#
# install groups and associate to domain/adlists
#
export PATH="$PATH:/usr/bin:/usr/local/bin/"

#installed domainlist ids
WHOLEWEB=1
GAMING=2
SOCIAL=3
STREAMING=4
YOUTUBE=5
FACEBOOKINSTA=6
TIKTOK=7

# installed adlist ids; #1 is StevenBlack list
ADULTGAMBLING=2

# should redesign groups: TV, Kids Phones & Tablets, Gaming Devices, 
# Kids Laptops, Work Laptops, 

# installed Groups
DEFAULT=0
KIDS=1
KIDSPHONES=2
TV=3
S=4
LAPTOPS=5


echo "adding Group 'Kids' to gravity.db as group ID=1 (Default is group id=0)"
sqlite3 /etc/pihole/gravity.db "insert or ignore into 'group' (enabled, name, description) VALUES ($KIDS, 'Kids', 'Devices the kids could use');"
sqlite3 /etc/pihole/gravity.db "insert or ignore into 'group' (enabled, name, description) VALUES (${KIDSPHONES}, 'Kids-Phones', 'Kids\' Phones');"
sqlite3 /etc/pihole/gravity.db "insert or ignore into 'group' (enabled, name, description) VALUES ($TV, 'TV', 'TV');"
sqlite3 /etc/pihole/gravity.db "insert or ignore into 'group' (enabled, name, description) VALUES ($S, 'S', 'S');"
sqlite3 /etc/pihole/gravity.db "insert or ignore into 'group' (enabled, name, description) VALUES ($LAPTOPS, 'Laptops', 'Laptops');"
sqlite3 /etc/pihole/gravity.db ".dump group"



echo "associate Adlists to Default and Kids group ID=1 (Default is group id=0)"
sqlite3 /etc/pihole/gravity.db "insert or ignore into adlist_by_group (adlist_id, group_id) VALUES ($ADULTGAMBLING, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into adlist_by_group (adlist_id, group_id) VALUES ($ADULTGAMBLING, ${KIDSPHONES});"
sqlite3 /etc/pihole/gravity.db "insert or ignore into adlist_by_group (adlist_id, group_id) VALUES ($ADULTGAMBLING, $TV);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into adlist_by_group (adlist_id, group_id) VALUES ($ADULTGAMBLING, $S);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into adlist_by_group (adlist_id, group_id) VALUES ($ADULTGAMBLING, $LAPTOPS);"
sqlite3 /etc/pihole/gravity.db ".dump adlist_by_group"


sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($WHOLEWEB, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($GAMING, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($SOCIAL, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($STREAMING, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($YOUTUBE, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($FACEBOOKINSTA, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($TIKTOK, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($WHOLEWEB, ${KIDSPHONES});"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($GAMING, ${KIDSPHONES});"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($SOCIAL, ${KIDSPHONES});"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($STREAMING, ${KIDSPHONES});"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($YOUTUBE, ${KIDSPHONES});"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($FACEBOOKINSTA, ${KIDSPHONES});"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($TIKTOK, ${KIDSPHONES});"
sqlite3 /etc/pihole/gravity.db ".dump domainlist_by_group"
