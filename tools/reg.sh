#!/bin/bash
# $Id: $

ME=$(basename $0)
USAGE="Usage: $ME 4|5 start end [key]"

THIRD=$1
START=$2
END=$3
KEY=$4

if [[ $THIRD == *[!0-9]* ]] || [ $THIRD -ne 4 -a $THIRD -ne 5 ]
then
    echo "Third octet must be 4 or 5"
    echo $USAGE
    exit 1
fi

if [[ $START == *[!0-9]* ]]
then
    echo "Limits must be numeric."
    echo $USAGE
    exit 1
fi

if [[ $END == *[!0-9]* ]]
then
    echo "Limits must be numeric."
    echo $USAGE
    exit 1
fi

if [ -z $START -o -z $END ]
then
    echo "You must provide a starting and ending octet."
    echo $USAGE
    exit 1
fi

if [ $END -lt $START ]
then
    echo "Invalid limits: $START $END "
    echo $USAGE
    exit 1
fi

if [ -z $KEY ]
then
    KEY=pass
fi

for ((n=$START; n<=$END; n++))
do
    echo "192.168.$THIRD.$n"
done | while read host
do
    date
    echo $host
    echo register_appliance.pl -h "$host" -k "$KEY" -l "PROTECT,CONTROL,URLFilter,MALWARE" #>>/var/log/reg.log 2>&1
done
