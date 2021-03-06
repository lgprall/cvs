#!/bin/bash

# $Id: chk_cores.sh,v 1.30 2012/08/03 09:59:54 larry Exp $
# Check for core files on a list of hosts

while getopts 'bqsvx:' OPTION
do
    case $OPTION in
    x)    EXCLUDE="$EXCLUDE $OPTARG"
        ;;
    s)    SHOW=1
        ;;
    v)    FULL=1
        ;;
    q)    QUIET=1
    	;;
    b)    BUILDOUT=1
        ;;
    h|?)  echo "Valid options are '-x exclude', '-v' all, '-s' show hosts, '-q' quiet, and '-b' use alternate file."
          exit 0
        ;;
    esac
done
shift $(($OPTIND - 1))

HOSTS=$@

HOSTLIST="~/lib/hostlist"
if test -z "$BUILDOUT"
then
    HOSTLIST="~/lib/blist"
fi
if test -z "$HOSTS"
then
    HOSTLIST="hostlist"
    if [ "$BUILDOUT" ]
    then
        HOSTLIST="blist"
    fi
    . ~/lib/$HOSTLIST
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

if [ -n "$FULL" ]
then
	for host in $HOSTS; do echo "=====> $host"; ssh root@$host 'uname -n
	. /etc/sf/ims.conf
		FILE=$ETC_PATH/PM.conf
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
		
		if [ -d /var/common/ ]
		then
			cd /var/common/
			for file in $(ls -tr core*); do ls -ld --full-time $file; file $file; done 
			echo
		fi
	'; done 2>/dev/null
	echo
elif [ -n "$QUIET" ]
then
	for host in $HOSTS; do ssh root@$host '
	. /etc/sf/ims.conf
	cd /var/common/
	TMP="/tmp/cl$$"
	(for file in $(ls -tr core*); do ls -ld --full-time $file; file $file; done) > $TMP
	if [ -s $TMP ]
	then
		echo "=====> $(hostname)"
		cat $TMP
		echo
	fi
	'; done 2>/dev/null
	echo
else
	for host in $HOSTS; do echo "=====> $host"; ssh root@$host 'uname -n
	. /etc/sf/ims.conf
	FILE=$ETC_PATH/PM.conf
	grep -q "/var/log/SFD.log" $FILE
	if [ $? -ne 0 ]
	then
		echo
		echo "       >>>>>>>> SFD logging not turned on"
		echo
	fi
	cd /var/common/
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
	'; done 2>/dev/null
fi
