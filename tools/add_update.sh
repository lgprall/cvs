#!/bin/sh

# $Id$

FILES="$@"
for file in $FILES
do
	echo "Processing $file"
	if [ ! -r $file ]
	then
		echo "		\"$file\" is not a valid file for installation"
		continue
	fi
	echo "Installing $file"
	scp $file install:/home/www/support_files/auto/files/
done

ssh install perl /home/www/support_files/auto/bin/build.pl


