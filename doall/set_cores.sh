#!/bin/bash

# $Id: set_cores.sh,v 1.9 2009/02/04 21:47:54 larry Exp $
# Turn on cores and SFDataCorrelator debugging on a list of hosts

HOSTS=$@

if test -z "$HOSTS"
then
HOSTS="csi sato glory kiesa entourage deathstar firman lightning2 lorne ocean12 xander ocean11 fightclub klitschko cuttingclass beingjohn";
fi
for host in $HOSTS; do echo "=====> $host"; ssh $host 'uname -n
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
grep -q "core;" $FILE
if [ $? -ne 0 ]
then
/bin/ed $FILE <<EOF
1i
core;
.
wq
EOF
fi

grep -q "logfile /var/tmp/SFD.log;" $FILE
if [ $? -ne 0 ]
then
/bin/ed $FILE <<EOF1
/option --nodaemon/a
    option --debug;
    logfile /var/tmp/SFD.log;
.
wq
EOF1

$SF_ETC_ROOT_PATH/etc/rc.d/init.d/pm restart > /dev/null
fi
'; done 2>/dev/null
