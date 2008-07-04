#!/bin/bash

HOSTS=$@
if test -z "$HOSTS"
then
HOSTS="csi sato glory entourage barret firman lightning2 ocean12 eko xander ocean11 fightclub klitschko cuttingclass beingjohn";
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
/option --nodaemon/a
    option --debug;
    logfile /var/log/SFD.log;
.
wq
EOF

$SF_ETC_ROOT_PATH/etc/rc.d/init.d/pm restart > /dev/null
fi
'; done 2>/dev/null

ssh firman /usr/local/bin/set_kcores.sh
