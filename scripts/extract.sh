#!/bin/bash

TODOVIDEOPATH=/root/vatic/data/videos_in
DONEVIDEOPATH=/root/vatic/data/videos_out
TODOIMAGEPATH=/root/vatic/data/images_in
DONEIMAGEPATH=/root/vatic/data/images_out
FRAMEPATH=/root/vatic/data/frames_in

mkdir -p $FRAMEPATH
mkdir -p $DONEVIDEOPATH

cd /root/vatic
for i in $( ls $TODOVIDEOPATH); do
    mkdir $FRAMEPATH/$i
    turkic extract $TODOVIDEOPATH/$i $FRAMEPATH/$i --no-resize
    mv $TODOVIDEOPATH/$i $DONEVIDEOPATH/
done

for i in $( ls $TODOIMAGEPATH); do
    mkdir $FRAMEPATH/$i
	turkic formatframes $TODOIMAGEPATH/$i $FRAMEPATH/$i
    mv $TODOIMAGEPATH/$i $DONEVIDEOPATH/
done
