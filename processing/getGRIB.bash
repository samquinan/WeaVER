#!/bin/bash

if [[ $# != 2 ]]; then
	echo "Usage: getGRIB.sh DATE MCYCLE"
	exit 1
fi

TDATE="$1"
MCYCLE=`printf "%02d" ${2#0}`

echo "downloading SREF CONUS (40km) from NOMADS to ./data/"
## you can change the data and the model cycle
#TDATE=20140115
#MCYCLE=21

## Might need to change the variable X if the URL you are downloading has different structure from the one below
## http://nomads.ncep.noaa.gov/pub/data/nccf/com/sref/prod/sref.20130301/09/pgrb/
# DURL=http://nomads.ncep.noaa.gov/pub/data/nccf/com/sref/prod/sref.
# DDIR=$DURL$TDATE/$MCYCLE/'pgrb'

# http://nomads.ncep.noaa.gov/cgi-bin/filter_sref.pl?file=sref_em.t15z.pgrb212.ctl.f00.grib2&lev_surface=on&var_ACPCP=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fsref.20140203%2F15%2Fpgrb

DURL="http://nomads.ncep.noaa.gov/cgi-bin/filter_sref.pl?file="
DURL2="&lev_2_m_above_ground=on&lev_10_m_above_ground=on&lev_200_mb=on&lev_300_mb=on&lev_500_mb=on&lev_700_mb=on&lev_850_mb=on&lev_950_mb=on&lev_surface=on&var_APCP=on&var_DPT=on&var_HGT=on&var_RH=on&var_TMP=on&var_UGRD=on&var_VGRD=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fsref.$TDATE%2F$MCYCLE%2Fpgrb"
#DURL2="&lev_2_m_above_ground=on&lev_10_m_above_ground=on&lev_500_mb=on&lev_700_mb=on&lev_750_mb=on&lev_850_mb=on&lev_surface=on&var_APCP=on&var_HGT=on&var_RH=on&var_TMP=on&var_UGRD=on&var_VGRD=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fsref.$TDATE%2F$MCYCLE%2Fpgrb"

## putting together the filename
MODELLIST="em nmb nmm"
PERTLIST="ctl n1 p1 n2 p2 n3 p3"
NGRID=212
#FRCSTH=12

WGRIB=wgrib2
DATADIR=./'data'/'grib'/$TDATE
TXTDIR=./data/fields/$DATE

## create download directory if doesn't exist
mkdir -p $DATADIR

## for loop to download
## can use this loop to download all the forecast hours
#for HOUR in $FRCSTH;
#do
	
for FRCSTH in `seq -w 0 3 87`
do
	for MODEL in $MODELLIST;
	do
		for PERT in $PERTLIST;
		do
			FNAME='sref_'$MODEL'.t'$MCYCLE'z.pgrb'$NGRID'.'$PERT'.f'$FRCSTH'.grib2'			
			#echo "$DURL$FNAME$DURL2"
			curl "$DURL$FNAME$DURL2" -o $DATADIR/$FNAME
		done
	done
done
 
