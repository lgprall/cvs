#!/bin/bash

# $Id: set_cores.sh,v 1.16 2010/04/23 11:05:13 larry Exp $
# Turn on cores and SFDataCorrelator debugging on a list of hosts

EXCLUDE=""

while getopts 'cdshx:' OPTION
do
    case $OPTION in
    s)    SHOW=1
        ;;
    x)    EXCLUDE="$EXCLUDE $OPTARG"
        ;;
    c)    CORES=1
        ;;
    d)    DEBUG=1
        ;;
    h|?)  echo "Valid options are:"
          echo "  -x exclude_host" 
          echo "          Exclude this host; can be used multiple times." 
          echo "  -s" 
          echo "          Show list of hosts to be acted upon." 
          echo "  -c" 
          echo "          Set cores only; no debug." 
          echo "  -d" 
          echo "          Set debug only; no cores." 
          exit 0
        ;;
    esac
done
shift $(($OPTIND - 1))
if [ -n "$CORES" -a -n "$DEBUG" ]
then
	echo '-c and -d cannot be used together'
	exit 0
fi
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
if [ -z '$DEBUG' ]
then
	grep -q "core;" $FILE
	if [ $? -ne 0 ]
	then
		/bin/ed $FILE <<-EOF
		1i
		core;
		.
		wq
		EOF
	fi
fi
if [ -z '$CORES' ]
then
	grep -q "logfile /var/log/SFD.log;" $FILE
	if [ $? -ne 0 ]
	then
		/bin/ed $FILE <<-EOF1
		/option --nodaemon/a
		    option --debug;
		    logfile /var/log/SFD.log;
		.
		wq
		EOF1
	fi
fi

$SF_ETC_ROOT_PATH/etc/rc.d/init.d/pm restart > /dev/null
'; done 2>/dev/null
