#!/bin/sh
args=($@)


echo "num args="$#
for arg in "${args[@]}"; do
	echo $arg
done
