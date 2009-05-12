#!/bin/bash

# $Id: set_cores.sh,v 1.13 2009/05/12 11:39:14 larry Exp $
# Turn on cores and SFDataCorrelator debugging on a list of hosts

EXCLUDE=""

while getopts 'shx:' OPTION
do
    case $OPTION in
    s)    SHOW=1
        ;;
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
wq
EOF
fi

grep -q "logfile /var/tmp/SFD.log;" $FILE
if [ $? -ne 0 ]
then
/bin/ed $FILE <<EOF1
/option --nodaemon/a
    option --debug;
    logfile /var/tmp/SFD.log;
.
wq
EOF1

$SF_ETC_ROOT_PATH/etc/rc.d/init.d/pm restart > /dev/null
fi
'; done 2>/dev/null
