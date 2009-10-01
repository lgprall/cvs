#!/bin/sh

# $Id: update_support.sh,v 1.1 2009/10/01 11:57:50 larry Exp $

# Must be run from current build (Testing) directory

ssh frodo rm -f /home/www/support_files/auto/files/*SamplePatch*.sh
cd /nfs/netboot/upgrades/Testing
cd $(ls -tr | tail -1)
for file in *SamplePatch*.sh
do
scp $file frodo:/home/www/support_files/auto/files/
done

ssh frodo perl /home/www/support_files/auto/bin/build.pl


