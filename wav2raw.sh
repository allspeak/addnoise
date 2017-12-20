#!/bin/bash

#
# Usage: wav2raw [-r <rate>] <folder>
#
# Default rate: 16000
#

RATE=16000

while getopts "r" opt; do
  case $opt in
    r)
    	RATE=$OPTARG;
  esac
done

shift $((OPTIND - 1));

find $1 -type f -iname '*.wav' -print0 | while IFS= read -r -d '' f; do
	newF="${f/[Ww][Aa][Vv]/raw}";
	echo $newF;
	sox -e signed-integer -b 16 -r $RATE -c 1 "$f" "$newF";
done
