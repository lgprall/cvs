#!/bin/bash

# $Id: chk_cores.sh,v 1.15 2009/05/12 11:47:40 larry Exp $
# Check for core files on a list of hosts

EXCLUDE=""

while getopts 'sx:' OPTION
do
    case $OPTION in
    x)    EXCLUDE="$EXCLUDE $OPTARG"
        ;;
    s)    SHOW=1
        ;;
    h|?)  echo "Valid options are '-x exclude_host' and '-s' to show hosts"
          exit 0
        ;;
    esac
done
shift $(($OPTIND - 1))

HOSTS=$@

if test -z "$HOSTS"
then
. ~/lib/hostlist
fi

for NOT in $EXCLUDE
do
HOSTS=${HOSTS/ $NOT / }
done

if [ "$SHOW" ]
then
    echo "Hosts: $HOSTS"
    exit 0
fi

for host in $HOSTS; do echo "=====> $host"; ssh $host 'uname -n
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
if [ -d $SF_DATA_ROOT_PATH/var/tmp/core ]
then
	cd $SF_DATA_ROOT_PATH/var/tmp/core
	COUNT=$(ls core* | wc -l)
	if [ 5 -lt $COUNT ]
	then
		echo "=============================================================================="
		echo "++++++++++++++++++++++++++++++ Found ${COUNT// /} cores ++++++++++++++++++++++++++++++++"
		echo "=============================================================================="
	else
		for file in $(ls -tr); do ls -ld --full-time $file; file $file; done 
	fi
fi
echo
'; done 2>/dev/null
