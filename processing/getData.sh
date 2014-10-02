#!/bin/bash
if [[ $# != 2 ]]; then
	echo "Usage: getData.sh DATE MCYCLE"
	exit 1
fi

DATE="$1"
MCYCLE=`printf "%02d" ${2#0}`

echo "fetching data..."
./getGRIB.bash $DATE $MCYCLE

echo "unpacking..."
./processGRIB.bash $DATE $MCYCLE

echo "generating derived data..."
./generate.sh $DATE $MCYCLE

echo "generating contour box plots..."
./genCBP.sh $DATE $MCYCLE

echo "consolidating..."
 ./curate.sh $DATE $MCYCLE