#!/bin/bash
export LANG=C.UTF-8
export LANGUAGE=en_US

# Settings
VIDEOPATH=/root/vatic/data/videos_in
VIDEO_OUT_PATH=/root/vatic/data/videos_out
ANNOTATEDFRAMEPATH=/root/vatic/data/frames_in
LABEL_FILE=/root/vatic/data/labels.txt
OUTPUT_DIR=/root/vatic/data/output
if [ -f "$LABEL_FILE" ]
then
    LABELS=`cat $LABEL_FILE`
    echo "Labels = $LABELS"
else
    echo "!!! data/labels.txt is required !!!!"
    echo "This file is a single line space seperated list of label names"
    exit 1
fi

NEWVIDEO=0
OLDVIDEO=0
if [ -d "/root/vatic/data" ]
then
    if [ -d ${VIDEOPATH} ]
    then
        if test "$(ls -A ${VIDEOPATH} 2>/dev/null)"
        then
            echo "New Videos to process."
            NEWVIDEO=1
        else
            echo "No new videos to process."
        fi
   fi
fi

if [ ! -e ${OUTPUT_DIR} ]
then
    mkdir -p ${OUTPUT_DIR}
fi

if [ -d ${ANNOTATEDFRAMEPATH} ]
then
    OLDVIDEO=1
fi
if [ ${NEWVIDEO} -eq 0 -a  ${OLDVIDEO} -eq 0 ]
then
    echo "!!!No new video or access to previous video's frames!!!"
    exit 1
fi

# Start database and server
/root/vatic/startup.sh

# Convert videos that need to be converted
/root/vatic/extract.sh

# Set up folders
mkdir -p $ANNOTATEDFRAMEPATH
cd /root/vatic

mkdir -p /root/vatic/public/directory

if [ -f /root/vatic/data/db.mysql ];
then
    echo "Reading in previous database"
    mysql -u root < /root/vatic/data/db.mysql
fi

OUTPUT_HTML=/root/vatic/public/directory/index.html

if [ -f ${OUTPUT_HTML} ];
then
    rm ${OUTPUT_HTML}
fi

touch ${OUTPUT_HTML}
chmod 755 ${OUTPUT_HTML}

# add some user interface controls
cat $PWD/ascripts/myhtml.html >> ${OUTPUT_HTML}

i=0

for p in $(ls $VIDEO_OUT_PATH); do
    video=`echo $p | tr -d " "`
    turkic load $video "${ANNOTATEDFRAMEPATH}/${video}" $LABELS $TURKOPS --offline
    videos[i]=${video}
    ((i++))
done

i=0

echo "<body>" >> ${OUTPUT_HTML}
echo "<table>" >> ${OUTPUT_HTML}

for u in $(turkic publish --offline); do
    HREF=$(echo $u|sed "s|http://localhost|\.\.|")
    echo "<tr>" >> ${OUTPUT_HTML}
    echo "<td><a href=\"${HREF}\">${videos[i]}</a></td>" >> ${OUTPUT_HTML}
    echo "<td><a href=\"#\" onclick='callLabelphp(\"${videos[i]}\")'>output</a></td>" >> ${OUTPUT_HTML}
    echo "<td><a href=\"#\" onclick='callVisualize(\"${videos[i]}\")'>visualize</a></td>" >> ${OUTPUT_HTML}
    echo "<tr />" >> ${OUTPUT_HTML}
    ((i++))
done

echo "</table>" >> ${OUTPUT_HTML}
echo "</body>" >> ${OUTPUT_HTML}
echo "</html>" >> ${OUTPUT_HTML}


cp $PWD/ascripts/myphp.php  /root/vatic/public/directory
chgrp -R www-data /root/vatic/data
chmod 775 /root/vatic/data

cp -r /root/vatic/data/frames_in/* /root/vatic/public/frames/

# open up a bash shell on the server
/bin/bash
