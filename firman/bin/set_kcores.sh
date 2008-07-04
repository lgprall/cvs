#!/bin/bash

echo "=====> kiesa"
ssh kiesa ' uname -n
. /etc/sf/ims.conf
FILE=$SF_ETC_ROOT_PATH/etc/sf/PM.conf
grep -q "core;" $FILE
if [ $? -ne 0 ]
then
/bin/ed $FILE <<EOF
1i
core;
.
/option --nodaemon/a
    option --debug;
    logfile /var/log/SFD.log;
.
wq
EOF

$SF_ETC_ROOT_PATH/etc/rc.d/init.d/pm restart > /dev/null
fi
' 2>/dev/null

