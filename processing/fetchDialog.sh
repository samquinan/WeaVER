#!/bin/bash

# Current Run -- 
# note: Approximated from current date/time; not guaranteed to be ready on server
# On average SREF runs currently complete running in under 4 hours 
# (see progress at http://www.nco.ncep.noaa.gov/pmb/nwprod/prodstat/)

# Get current UTC hour
H_CUR=$(date -u +"%H")
# Get approximated run start hour
printf -v RUN_CUR "%02d" $[$[$[$[$[$[10#$H_CUR-7]+24]%24]/6]*6]+3]

# Handling 24 wraparound on date 
if [ $H_CUR -lt 7 ] 
then
	if date -v -1d > /dev/null 2>&1; then 
	  # OSX BSD date command for yesterday   
	  DATE_CUR=$(date -u -v -1d +"%Y%m%d")
	else
	  # Linux GNU date command for yesterday
	  DATE_CUR=$(date -u --date="1 day ago" +"%Y%m%d")
	fi
else
    # Today's date
	DATE_CUR=$(date -u +"%Y%m%d")
fi

# Generate Dialog
echo
echo "------------------------"
echo "Fetch Data Dialog"
echo "------------------------"
echo "Latest Run is:"
echo "    "$DATE_CUR"    t"$RUN_CUR"z"
read -p "Fetch latest run? [Yy/Nn]: " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    DATE=$DATE_CUR
	RUN=$RUN_CUR
elif [[ $REPLY =~ ^[Nn]$ ]]
then
	# note: probably want to validate inputs for production use...
	read -p "Choose Date [YYYYMMDD]: "
	DATE=$REPLY
	read -p "Choose Run [03,09,15,21]: "
	echo
	RUN=$REPLY
else
	echo Unrecognized input. Exiting...
	sleep 2
	exit
fi
echo

# Move to the directory where this script is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Run Get Data
./getData.sh $DATE $RUN

