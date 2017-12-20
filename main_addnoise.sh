src_folder=/data/AllSpeak/DATA/all/WAV/controls/codes/allcontrols

AUDIO_CUT_SEED=10 # can be whichever number...makes the audio cut (whether src audio is shorter than noise file) reproducible

# create input file list
find $src_folder -type f -iname '*.wav' > $src_folder/wav_in.txt

declare -a noises=(cafeteria gauss2 square subway)
declare -a snrs=(10 15 10 10)
declare -i cnt=0

for s in ${noises[@]}
do
	
	for f in $src_folder/*$s.raw; do rm $f; done
	outlist=$src_folder/${s}_wav_out.txt
	sed "s|\.wav|.${s}_snr_${snrs[cnt]}.wav|g" $src_folder/wav_in.txt > $outlist
	bash addnoise.sh -r 8000 -s ${snrs[cnt]} -n noises/$s.wav -d $AUDIO_CUT_SEED $src_folder/wav_in.txt $outlist
	cnt=$cnt+1
done

for f in $src_folder/*raw; do rm $f; done


