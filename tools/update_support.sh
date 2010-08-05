#!/bin/sh

# $Id: update_support.sh,v 1.3 2010/08/05 10:22:45 larry Exp $

# Must be run from current build (Testing) directory

ssh install rm -f /home/www/support_files/auto/files/*SamplePatch*.sh
cd /nfs/netboot/upgrades/Testing
cd $(ls -tr | tail -1)
for file in *SamplePatch*.sh
do
scp $file install:/home/www/support_files/auto/files/
done

ssh install perl /home/www/support_files/auto/bin/build.pl


