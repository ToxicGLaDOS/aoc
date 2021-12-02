#!/usr/bin/env bash
set -e

input="../input/day2-1.txt"
horz=0
depth=0
while read -r line; do
	if [[ $line =~ forward\ ([0-9]+) ]]; then
		value="${BASH_REMATCH[1]}"
		horz=$(($horz+$value))

	elif [[ $line =~ up\ ([0-9]+) ]]; then
		value="${BASH_REMATCH[1]}"
		depth=$(($depth-$value))

	elif [[ $line =~ down\ ([0-9]+) ]]; then
		value="${BASH_REMATCH[1]}"
		depth=$(($depth+$value))
	fi
done < "$input"


echo "Horz $horz, Depth $depth, Product $(($depth*$horz))"
