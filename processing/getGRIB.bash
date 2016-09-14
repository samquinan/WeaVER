#!/bin/bash

# NOTE: This version of the download script uses NCEP's NOMADS Server's GRIB filter. 		#
# 		If you are using this script regularly, you may want to look into using partial http  #
#		transfers (http://www.cpc.ncep.noaa.gov/products/wesley/fast_downloading_grib.html)  #    
#		to download the data from the more reliable NCO servers. 							#

# Assumes valid date / run inputs
if [[ $# != 2 ]]; then
	echo "Usage: getGRIB.sh DATE RUN"
	exit 1
fi

## Processing date and model cycle inputs
DATE="$1"
RUN=`printf "%02d" ${2#0}`

echo "downloading SREF CONUS (40km) from NOMADS to ./data/"

## Building the NOMADS server grib filter URL
DURL="http://nomads.ncep.noaa.gov/cgi-bin/filter_sref.pl?file="
## Filters for height levels / variables
DURL2="&lev_2_m_above_ground=on&lev_10_m_above_ground=on&lev_200_mb=on&lev_300_mb=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_950_mb=on&lev_surface=on&var_APCP=on&var_DPT=on&var_HGT=on&var_RH=on&var_TMP=on&var_UGRD=on&var_VGRD=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fsref.$DATE%2F$RUN%2Fpgrb"

## Putting together the filename
MODELLIST="arw nmb" ## for runs from before 10/21/2015 -- "em nmb nmm"
PERTLIST="ctl n1 p1 n2 p2 n3 p3 n4 p4 n5 p5 n6 p6" ## for runs from before 10/21/2015 -- "ctl n1 p1 n2 p2 n3 p3"
NGRID=212

## Directory Setup
DATADIR=./'data'/'grib'/$DATE

## Create download directory if doesn't exist
mkdir -p $DATADIR

for FRCSTH in `seq -w 0 3 87` ## For each forecast hour
do
	for MODEL in $MODELLIST; ## For each model
	do
		for PERT in $PERTLIST; ## For each perturbation
		do
			## Generate file name
			FNAME='sref_'$MODEL'.t'$RUN'z.pgrb'$NGRID'.'$PERT'.f'$FRCSTH'.grib2'
			## Download	via GRIB Filter		
			curl -f "$DURL$FNAME$DURL2" -o $DATADIR/$FNAME
		done
	done
done
 
