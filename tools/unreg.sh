#!/bin/bash

# $Id: unreg.sh,v 1.1 2015/08/20 12:49:51 larry Exp $

mysql -padmin sfsnort -e 'select uuid from EM_peers where role = 2 and active = 1'  | awk '{print}' | while read host
do
    date
    echo $host
    remove_peer.pl $host 2>/dev/null
done
date
