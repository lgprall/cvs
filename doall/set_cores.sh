#!/bin/bash

KIESA=0
while getopts k FWD
do
   case $FWD in
      k) KIESA=1
         ;;
     \?) echo "Use -k to include Kiesa in specific list"
      	 exit 1
         ;;
   esac
done
shift $(( $OPTIND - 1 ))
      
HOSTS=$@

if test -z "$HOSTS"
then
HOSTS="csi sato glory entourage barret firman lightning2 ocean12 eko xander ocean11 fightclub klitschko cuttingclass beingjohn";
KIESA=1
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
    logfile /var/tmp/SFD.log;
.
wq
EOF

$SF_ETC_ROOT_PATH/etc/rc.d/init.d/pm restart > /dev/null
fi
'; done 2>/dev/null

if test $KIESA -eq 1
then
	ssh firman /usr/local/bin/set_kcores.sh 2>/dev/null
fi
