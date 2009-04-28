#!/bin/bash

# $Id: chk_cores.sh,v 1.9 2009/04/28 13:18:59 larry Exp $
# Check for core files on a list of hosts

EXCLUDE=""

while getopts 'x:' OPTION
do
    case $OPTION in
    x)    EXCLUDE="$EXCLUDE $OPTARG"
        ;;
    h|?)  echo "Valid options are '-x exclude_host'"
          exit 0
        ;;
    esac
done
shift $(($OPTIND - 1))

HOSTS=$@

if test -z "$HOSTS"
then
HOSTS=" csi sato glory entourage kiesa firman lightning2 lorne ocean12 xander ocean11 fightclub klitschko cuttingclass beingjohn ";
fi

for NOT in $EXCLUDE
do
HOSTS=${HOSTS/ $NOT / }
done

for host in $HOSTS; do echo "=====> $host"; ssh $host 'uname -n
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
if [ -d /var/tmp/core ]
then
	cd /var/tmp/core
	COUNT=$(ls core* | wc -l)
	if [ 5 -lt $COUNT ]
	then
		echo "More than five cores"
	else
		for file in $(ls -tr); do ls -ld --full-time $file; file $file; done 
	fi
fi
echo
'; done 2>/dev/null
