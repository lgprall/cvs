#!/bin/bash

# $Id: chk_hosts.sh,v 1.5 2009/05/12 11:27:15 larry Exp $
# Run a (limited) command on a list of hosts

EXCLUDE=""

while getopts 'sx:e:' OPTION
do
	case $OPTION in
	s) 	SHOW=1
		;;
	x)	EXCLUDE="$EXCLUDE $OPTARG"
		;;
	e)	COMMAND="$OPTARG"
		;;
	h|?)	echo "Valid options are:"
		echo "	-x exclude_host"
		echo "		Exclude this host; can be used multiple times."
		echo "	-s "
		echo "		Show list of hosts to be sent the command."
		echo "	-e command"
		echo "		Execute this command on each host in the list"
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

if [ "$SHOW" -o -z "$COMMAND" ]
then
	echo "Hosts: $HOSTS"
	exit 0
fi

for host in $HOSTS; do echo "=====> $host"; ssh $host <<ACTION
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
eval $COMMAND
echo
ACTION
done 2>/dev/null
