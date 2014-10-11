#!/bin/bash

if [ -z "$1" -o "$1" = "--help" ]; then
	echo usage $0 Stunde Minute
fi

DEST_HOUR=$1
DEST_MINUTE=$2
HOUR=$(date "+%H")
MINUTE=$(date "+%M")

SECONDS=$(($DEST_HOUR*60*60 + $DEST_MINUTE*60 - $HOUR*60*60 - $MINUTE*60))

echo starting with $SECONDS seconds

if [ ! "$3" = "--play" ]; then
	sleep $SECONDS
fi
for i in $(seq 1 4); do
	say It is now $(date "+%H:%M"), good morning
	
	if [ $i -eq 1 ]; then
		afplay $i.mp3 &
		say So lets begin the day with funk\'o\'rama! 
		sleep 201
	else
		afplay $i.mp3 
	fi
done

