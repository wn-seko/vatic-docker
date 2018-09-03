#!/bin/bash

TODOVIDEOPATH=/root/vatic/data/videos_in
DONEVIDEOPATH=/root/vatic/data/videos_out
FRAMEPATH=/root/vatic/data/frames_pool

mkdir -p $FRAMEPATH
mkdir -p $DONEVIDEOPATH

cd /root/vatic
for i in $( ls $TODOVIDEOPATH); do
    mkdir $FRAMEPATH/$i
    turkic extract $TODOVIDEOPATH/$i $FRAMEPATH/$i --width 720 --height 480
    mv $TODOVIDEOPATH/$i $DONEVIDEOPATH/
done