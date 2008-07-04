#!/bin/bash

CMD=$@

echo "=====> kiesa"; ssh kiesa <<EOF 2>/dev/null
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
eval "$CMD"
EOF 

