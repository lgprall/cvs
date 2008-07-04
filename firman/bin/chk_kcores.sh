#!/bin/bash

echo "=====> kiesa"; ssh kiesa 'uname -n
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
if [ -d /var/tmp/core ]
then
cd /var/tmp/core; for file in $(ls -t); do ls -l --full-time $file; file $file; done 
fi
' 2>/dev/null

