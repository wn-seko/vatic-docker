ID=currentvideo
ANNOTATEDFRAMEPATH=/root/vatic/data/frames_in
TURKOPS="--offline --title HelloTurk!"
LABEL_FILE=/root/vatic/data/labels.txt

if [ -f "$LABEL_FILE" ]
then
    LABELS=`cat $LABEL_FILE`
else
    echo "!!! data/labels.txt is required !!!!"
    echo "This file is a single line space seperated list of label names"
    exit 1
fi

cd /root/vatic

# load frames and publish. This will print out access URLs.
turkic load $ID $ANNOTATEDFRAMEPATH $LABELS $TURKOPS > /dev/null
echo $(turkic publish --offline|sed "s|http://localhost|\.\.|")
