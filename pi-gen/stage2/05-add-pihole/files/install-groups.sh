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

# installed Groups
DEFAULT=0
KIDS=1

# CREATE TABLE IF NOT EXISTS "group"
# (
# 	id INTEGER PRIMARY KEY AUTOINCREMENT,
# 	enabled BOOLEAN NOT NULL DEFAULT 1,
# 	name TEXT UNIQUE NOT NULL,
# 	date_added INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)),
# 	date_modified INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)),
# 	description TEXT
# );
echo "adding Group 'Kids' to gravity.db as group ID=1 (Default is group id=0)"
sqlite3 /etc/pihole/gravity.db "insert or ignore into 'group' (enabled, name, description) VALUES (1, 'Kids', 'Devices the kids could use');"
sqlite3 /etc/pihole/gravity.db ".dump group"


# associate Adlists 2 to Default and Kids group
# CREATE TABLE adlist_by_group
# (
# 	adlist_id INTEGER NOT NULL REFERENCES adlist (id),
# 	group_id INTEGER NOT NULL REFERENCES "group" (id),
# 	PRIMARY KEY (adlist_id, group_id)
# );
echo "associate Adlists to Default and Kids group ID=1 (Default is group id=0)"
sqlite3 /etc/pihole/gravity.db "insert or ignore into adlist_by_group (adlist_id, group_id) VALUES ($ADULTGAMBLING, $KIDS);"
# need to do for default as well?
sqlite3 /etc/pihole/gravity.db ".dump adlist_by_group"

# associate domainlists to Default and Kids group ....
# CREATE TABLE domainlist_by_group
# (
# 	domainlist_id INTEGER NOT NULL REFERENCES domainlist (id),
# 	group_id INTEGER NOT NULL REFERENCES "group" (id),
# 	PRIMARY KEY (domainlist_id, group_id)
# );
echo "associate domainlists to Default and Kids group ID=1 (Default is group id=0)"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($WHOLEWEB, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($GAMING, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($SOCIAL, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($STREAMING, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($YOUTUBE, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($FACEBOOKINSTA, $KIDS);"
sqlite3 /etc/pihole/gravity.db "insert or ignore into domainlist_by_group (domainlist_id, group_id) VALUES ($TIKTOK, $KIDS);"
sqlite3 /etc/pihole/gravity.db ".dump domainlist_by_group"
