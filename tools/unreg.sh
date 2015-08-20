#!/bin/bash

# $Id: $

cat uuids.txt | while read host
do
    date
    echo $host
    remove_peer.pl $host
done
date
