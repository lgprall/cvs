#!/bin/bash

HOSTS=$@
if test -z "$HOSTS"
then
HOSTS="csi sato glory entourage barret firman lightning2 ocean12 eko xander ocean11 fightclub klitschko cuttingclass beingjohn";
fi
for host in $HOSTS; do echo "=====> $host"; ssh $host 'uname -n
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
if [ -d /var/tmp/core ]
then
cd /var/tmp/core; for file in $(ls -t); do ls -l --full-time $file; file $file; done 
fi
echo
'; done 2>/dev/null
ssh firman /usr/local/bin/chk_kcores.sh
