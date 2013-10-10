#!/bin/bash

# $Id: $
# Update the authorized keys list for root on a list of hosts

EXCLUDE=""

while getopts 'sx:e:' OPTION
do
	case $OPTION in
	s) 	SHOW=1
		;;
	x)	EXCLUDE="$EXCLUDE $OPTARG"
		;;
	h|?)	echo "Valid options are:"
		echo "	-x exclude_host"
		echo "		Exclude this host; can be used multiple times."
		echo "	-s "
		echo "		Show list of hosts to be updated."
		exit 0
		;;
	esac
done
shift $(($OPTIND - 1))

HOSTS=$@

if test -z "$HOSTS"
then
. /Users/larry/lib/hostlist
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

for host in $HOSTS; do echo "=====> $host"; scp /Users/larry/lib/authorized_keys root@$host:/tmp/newkeys;ssh root@$host ed .ssh/authorized_keys  2>/dev/null <<ACTION 
/habu.sf/,$ d
r /tmp/newkeys
w
q
rm /tmp/newkeys
ACTION
done 
