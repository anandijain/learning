#!/bin/sh
IN_STR=hello
while [ "$IN_STR" != "bye" ]
do
	echo "whatchu want (bye for exit)"
	read IN_STR
	echo "$IN_STR"
done
