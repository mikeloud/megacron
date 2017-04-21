#!/bin/bash

if [ -z "$1" ]
then 
	echo "I need a directory."
	exit 1
fi

target=$1
if find "$target" -mindepth 1 -print -quit | grep -q .; then
	echo "Directory not empty, continuing."
else
	echo "Directory is empty."
	exit 0
fi

if ! mkdir /tmp/sync.lock 2>/dev/null; then
	    echo "Could not get lock." >&2
	    exit 2
fi




for i in "$1"/*
do
	echo "$i"
	if test -f "$i"
	then 
		megaput --path=/Root/Complete "$i"
		rm "$i"
	else 
		if test -d "$i"
		then 
			megamkdir /Root/Complete/"$(basename $i)"
			megacopy -l "$i" -r /Root/Complete/"$(basename $i)"
			rm -rf "$i"
		fi
	fi
done

rm -rf /tmp/sync.lock
