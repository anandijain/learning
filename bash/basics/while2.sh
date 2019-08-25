#!/bin/sh
echo "what lang u want?"
while read f
do
	case $f in 
		hello)	echo En ;;
		howdy)	echo Amer ;;
		gday)	echo Aus ;;
		*)	echo Unknown ;;
	esac
done < myfile

