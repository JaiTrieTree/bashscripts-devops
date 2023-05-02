#!/bin/bash

# script to check if  disk space on the / partition or volume is less than 3GB or if less than 512 MB RAM is listed as free

# script to get the disk space on / partition
FREESPACE=$(($(df | grep -w / | awk '{print $4}')/1024))
echo $FREESPACE

# script to check free RAM
FREERAM=$(($(cat /proc/meminfo | grep MemFree | awk '{print $2}' )/1024))
echo $FREERAM

# to check both space and RAM condition
if [ $FREESPACE -le $(( 3 * 1024)) ] && [ $FREERAM -le 512 ]
then
        echo 'low system resource'
        exit 1
fi
if [ $FREERAM -le  512 ]
then 
        echo 'low memory is available'
	exit 1
fi
if [ $FREESPACE -le $(( 3*1024 )) ]
then 
        echo 'low disk available'
	exit 1
fi
echo "all resources are good"
