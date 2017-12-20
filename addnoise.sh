#!/bin/bash

# parameter -d to define the seed used to cut the noise signal (whether longer than the original signal) in a reproducible way
# this param reflects in the -r 10 params to: filter_add_noise

echo $@

USAGE="Usage: addnoise.sh [-r rate (default = 16000)] [-o output_folder (default = .)] -n noisefile -s snr -d 10 listin listout";
RATE=16000
OUTPUT_FOLDER="."
AUDIOCUT_SEED=10

# ":" for options that require an argument
while getopts "r:n:s:f:d:h" opt; do
  case $opt in
    r)
    	  RATE=$OPTARG;;
    n)
        NOISEFILE=$OPTARG;;
    s)
        SNR=$OPTARG;;
    f)
        OUTPUT_FOLDER=$OPTARG;;
    d)
        AUDIOCUT_SEED=$OPTARG;;
    h)
        echo "Help"
        echo $USAGE
        exit 0;;
    \?)
        echo "Unknown parameter"
        echo $USAGE
        exit 1;;
  esac
done

# shifting the options index to the next parameter we didn't take care of
shift $((OPTIND - 1));

echo optind:$OPTIND
echo $@

# Check mandatory arguments
if test -z $NOISEFILE || test -z $SNR || test -z $1 || test -z $2
then
    echo "Missing mandatory parameter"
    echo $USAGE
    exit 1
fi

rawfilename="$OUTPUT_FOLDER/rawlist.txt"
nrawfilename="$OUTPUT_FOLDER/nrawlist.txt"
> $rawfilename
> $nrawfilename

# Converting WAV files into RAW files
while read filein fileout
do
    filename=$(basename "$filein")
    raw_filename="$filein.raw"
    noisy_filename="$filein.noisy.raw"
	echo $raw_filename >> $rawfilename
	echo $noisy_filename >> $nrawfilename
    sox -e signed-integer -b 16 -r $RATE -c 1 "$filein" "$raw_filename"
done < $1

# Adding noise
if [ $RATE -eq 16000 ]; then
	./filter_add_noise -i rawlist.txt -o nrawlist.txt -n $NOISEFILE -s $SNR -r $AUDIOCUT_SEED -u $RATE 
else
	./filter_add_noise -i rawlist.txt -o nrawlist.txt -n $NOISEFILE -s $SNR -r $AUDIOCUT_SEED
fi

# Converting RAW files back to WAV files
while IFS= read -r filein <&3 && IFS= read -r fileout <&4
do
    sox -e signed-integer -b 16 -r $RATE -c 1 "$filein" "$fileout"
done 3<$nrawfilename 4<$2
