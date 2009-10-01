#!/bin/sh

# $Id$

# Must be run from current build (Testing) directory

cd /nfs/netboot/upgrades/Testing
cd $(ls -tr | tail -1)
for file in *SamplePatch*.sh
do
scp $file frodo:/home/www/support_files/auto/files/
done

ssh frodo perl /home/www/support_files/auto/bin/build.pl


