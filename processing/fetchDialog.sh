#!/bin/bash

H_CUR=$(date +"%H")
RUN_CUR=$[$[$[$[$[$[$H_CUR-3]+24]%24]/6]*6]+3]

if [ $H_CUR -lt 3 ] 
then
	if date -v -1d > /dev/null 2>&1; then
	  DATE_CUR=$(date -v -1d +"%Y%m%d")
	else
	  DATE_CUR=$(date --date="1 day ago" +"%Y%m%d")
	fi
else
	DATE_CUR=$(date +"%Y%m%d")
fi

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
else
	read -p "Choose Date [YYYYMMDD]: "
	DATE=$REPLY
	read -p "Choose Run [03,09,15,21]: "
	echo
	RUN=$REPLY
fi
echo

# RUN
./getData $DATE $RUN

