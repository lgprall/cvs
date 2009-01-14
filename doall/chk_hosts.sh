#!/bin/bash

# $Id$
# Run a (limited) command on a list of hosts

CMD=$@

HOSTS="csi sato glory entourage kiesa barret firman lightning2 lorne ocean12 eko xander ocean11 fightclub klitschko cuttingclass beingjohn";

for host in $HOSTS; do echo "=====> $host"; ssh $host "
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
eval $CMD
echo
"; done 2>/dev/null
