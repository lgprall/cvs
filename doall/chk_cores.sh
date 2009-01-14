#!/bin/bash

# $Id$
# Check for core files on a list of hosts

HOSTS=$@

if test -z "$HOSTS"
then
HOSTS="csi sato glory entourage kiesa barret firman lightning2 lorne ocean12 eko xander ocean11 fightclub klitschko cuttingclass beingjohn";
#HOSTS="csi sato glory entourage barret firman lightning2 lorne ocean12 eko xander ocean11 fightclub klitschko cuttingclass beingjohn";
KIESA=1
fi
for host in $HOSTS; do echo "=====> $host"; ssh $host 'uname -n
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
if [ -d /var/tmp/core ]
then
cd /var/tmp/core; for file in $(ls -tr); do ls -ld --full-time $file; file $file; done 
fi
echo
'; done 2>/dev/null
