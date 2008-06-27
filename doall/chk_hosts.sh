#!/bin/bash

CMD=$@

HOSTS="csi sato glory entourage barret firman lightning2 ocean12 eko xander ocean11 fightclub klitschko cuttingclass beingjohn";

for host in $HOSTS; do echo "=====> $host"; ssh $host "
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
eval $CMD
echo
"; done 2>/dev/null

ssh firman /usr/local/bin/chk_kiesa.sh "$CMD"

