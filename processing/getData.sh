#!/bin/bash

# Assumes valid date / run inputs
if [[ $# != 2 ]]; then
	echo "Usage: getData.sh DATE RUN"
	exit 1
fi

DATE="$1"
RUN=`printf "%02d" ${2#0}`

# The following wraps all data fetch and processing steps 

echo "fetching data..."
./getGRIB.bash $DATE $RUN

echo "unpacking..."
./processGRIB.bash $DATE $RUN

echo "generating derived data..."
./generate.sh $DATE $RUN

echo "generating contour box plots..."
./genCBP.sh $DATE $RUN

echo "consolidating..."
./curate.sh $DATE $RUN

# If you're going to script an update you're going to want to clear out old data for space. Below is code that will blow away any data that's older then 10 days.

#echo "cleanup: deleting data not created within the last 10 days..."
#find ./data  -maxdepth 2 -mindepth 1  -type d -ctime +10 -exec rm -rf {} +