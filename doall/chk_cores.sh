#!/bin/bash

# $Id: chk_cores.sh,v 1.28 2010/11/03 10:52:53 larry Exp $
# Check for core files on a list of hosts

EXCLUDE=""

while getopts 'svx:' OPTION
do
    case $OPTION in
    x)    EXCLUDE="$EXCLUDE $OPTARG"
        ;;
    s)    SHOW=1
        ;;
    v)    FULL=1
        ;;
    h|?)  echo "Valid options are '-x exclude_host', '-v' to show all, and '-s' to show hosts"
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

if [ -z "$FULL" ]
then
	for host in $HOSTS; do echo "=====> $host"; ssh $host 'uname -n
	. /etc/sf/ims.conf
	FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
        grep -q "core;" $FILE
	if [ $? -ne 0 ]
	then
		echo
		echo "       >>>>>>>> Cores not turned on"
		echo
		next
	fi
        grep -q "/var/log/SFD.log" $FILE
	if [ $? -ne 0 ]
	then
		echo
		echo "       >>>>>>>> SFD logging not turned on"
		echo
	fi
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
			for file in $(ls -tr core*); do ls -ld --full-time $file; file $file; done 
			echo
		fi
	elif [ -d $SF_DATA_ROOT_PATH/var/common/ ]
	then
		cd $SF_DATA_ROOT_PATH/var/common/
		COUNT=$(ls core* | wc -l)
		if [ 5 -lt $COUNT ]
		then
			echo "=============================================================================="
			echo "+++++++++++++++++++++++ Found ${COUNT// /} cores in /var/common ++++++++++++++++++++++++"
			echo "=============================================================================="
			echo
		else
			for file in $(ls -tr core*); do ls -ld --full-time $file; file $file; done 
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
				for file in $(ls -tr core*); do ls -ld --full-time $file; file $file; done
			fi
			echo
		done
	fi
	echo
	'; done 2>/dev/null
else
	for host in $HOSTS; do echo "=====> $host"; ssh $host 'uname -n
	. /etc/sf/ims.conf
	FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
	if [ -d $SF_DATA_ROOT_PATH/var/tmp/core ]
	then
		cd $SF_DATA_ROOT_PATH/var/tmp/core
		for file in $(ls -tr core*); do ls -ld --full-time $file; file $file; done 
		echo
	elif [ -d $SF_DATA_ROOT_PATH/var/common/ ]
	then
		cd $SF_DATA_ROOT_PATH/var/common/
		for file in $(ls -tr core*); do ls -ld --full-time $file; file $file; done 
		echo
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
			for file in $(ls -tr core*); do ls -ld --full-time $file; file $file; done
			echo
		done
	fi
	echo
	'; done 2>/dev/null
fi
