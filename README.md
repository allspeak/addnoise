# Adding noise to .wav files

1.  Install FaNT (http://aurora.hsnr.de/download.html)

2.  Install sox/soxi (http://sox.sourceforge.net/)

3.  Generate the list of input files

    For example, to list all files ending with `.wav` under directory `<dir>`, one can use:

    ```find <dir> -type f -iname '*.wav' > wav_in.txt```

    Do not use "." as a directory if you want absolute paths; use $PWD instead.

4.  Generate the list of output files

    e.g.: ```sed 's/\.wav/.noisy.wav/g' wav_in.txt > wav_out.txt```

3.  Add noise using the script addnoise.sh

    e.g.: ```addnoise.sh -n <noisefile> -s <snr> wav_in.txt wav_out.txt```

	Default rate is 16000Hz.<br />
	Default output folder is the current one

    Use `addnoise.sh -h` for the list of all parameters.

6. (OPTIONAL) Delete RAW files

    e.g.: ```find <dir> -name '*.raw' -delete```
# addnoise
