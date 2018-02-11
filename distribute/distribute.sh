#!/bin/bash

# passing argument 1. group name 2. file name 3 target folder name
# Put the distributing file in current directory

MEMBER=$(members $1)
FILE=$2
TARGET=$3

if [ ! -e $FILE ]
then
	echo "File doesn't exist in current directory. Distribution fail."
	exit
fi


for USER in $MEMBER; do
	if [ ! -d "/home/$USER/$TARGET" ]
	then
		mkdir "/home/$USER/$TARGET"
	fi
	cp -r "$FILE" "/home/$USER/$TARGET"
	chown -R "$USER" "/home/$USER/$TARGET/$FILE"
	chgrp -R "users" "/home/$USER/$TARGET/$FILE"
done 