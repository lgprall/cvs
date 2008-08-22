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
if [ -d /var/tmp/core ]
then
cd /var/tmp/core; for file in $(ls -t); do ls -ld --full-time $file; file $file; done 
fi
echo
'; done 2>/dev/null

if test $KIESA -eq 1
then
ssh firman /usr/local/bin/chk_kcores.sh 2>/dev/null
fi
