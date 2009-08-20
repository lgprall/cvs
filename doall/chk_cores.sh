#!/bin/bash

# $Id: chk_cores.sh,v 1.17 2009/08/20 10:38:18 larry Exp $
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
		echo "++++++++++++++++++++++++ Found ${COUNT// /} cores in /var/tmp ++++++++++++++++++++++++++"
		echo "=============================================================================="
		echo
	else
		for file in $(ls -tr); do ls -ld --full-time $file; file $file; done 
		echo
	fi
fi

ls $SF_DATA_ROOT_PATH/var/sf/detection_engines/*/instance*/var/tmp/core > /dev/null 2>&1

if [ 0 -eq $? ] 
then
	cd $SF_DATA_ROOT_PATH/var/sf/detection_engines
	for dir in $(ls -d */instance*/var/tmp/core)
	do
		cd $dir
                if [ ! -f core* ]; then continue; fi
		echo "   ====> in $dir"
		COUNT=$(ls core* | wc -l)
		if [ 5 -lt $COUNT ]
		then
			echo "=============================================================================="
			echo "++++++++++++++++++++++++++++++ Found ${COUNT// /} cores ++++++++++++++++++++++++++++++++"
			echo "=============================================================================="
		else
			for file in $(ls -tr); do ls -ld --full-time $file; file $file; done
		fi
		echo
	done
fi
echo
'; done 2>/dev/null
