#!/bin/bash

#
# Compose mp4 from mp3 and  animated picture.  Adding sign and 2 filters
#

out="out.mp4" #  output
disk="valk500tr.png" # for rotating disc
mp3="wagner_valkyries.mp3" # source mp3 
filter_filename="flr_show-freq-vol" #$1
 
data=$(ffprobe -i $mp3 2>&1 | egrep "artist|title") # get some data from mp3 metadada

#Uncomment len to get real duration
#len=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $mp3 ) #duration of input, sec
len=20 # for test only


filter=$(cat $filter_filename) # filter_complex in separate file

 
#Save  to file, because  filter "drawtext" can read it
echo $data > metadata.txt  
# encoding parameters
enc="-c:v h264 -crf 23 -preset medium -tune film  -b:v 3M -c:a aac -b:a 192k"
#executing string
exe=$(echo "ffmpeg  -i $mp3 -loop 1 -i $disk -y  -lavfi $filter -ss 00:00:00 -to $len $enc -shortest  -map '[fin]' -map 0:a $out")
echo $exe > run.sh
bash run.sh
#  rm tmp
rm run.sh
rm metadata.txt
