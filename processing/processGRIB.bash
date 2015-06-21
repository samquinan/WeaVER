#!/bin/bash

if [[ $# != 2 ]]; then
	echo "Usage: processGRIB.sh DATE MCYCLE"
	exit 1
fi

echo "Converting grib2 format to text"

#DATE='20130805'
DATE="$1"
MCYCLE=`printf "%02d" ${2#0}`

WGRIB=wgrib2
DATADIR=./data/grib/$DATE
TXTDIR=./data/fields/$DATE


mkdir -p $TXTDIR/'surface_APCP'/'3hr'/
mkdir -p $TXTDIR/'surface_APCP'/'total'/

mkdir -p $TXTDIR/'surface_APCP'/'3hr'/'derived'/
mkdir -p $TXTDIR/'surface_APCP'/'3hr'/'prob'/
mkdir -p $TXTDIR/'surface_APCP'/'6hr'/'derived'/
mkdir -p $TXTDIR/'surface_APCP'/'6hr'/'prob'/
mkdir -p $TXTDIR/'surface_APCP'/'12hr'/'derived'/
mkdir -p $TXTDIR/'surface_APCP'/'12hr'/'prob'/
mkdir -p $TXTDIR/'surface_APCP'/'24hr'/'derived'/
mkdir -p $TXTDIR/'surface_APCP'/'24hr'/'prob'/

mkdir -p $TXTDIR/'2m_RH'/'prob'/
mkdir -p $TXTDIR/'2m_RH'/'derived'/
mkdir -p $TXTDIR/'2m_TMP'/'derived'/
mkdir -p $TXTDIR/'2m_TMP'/'prob'/
mkdir -p $TXTDIR/'2m_DPT'/'derived'/
mkdir -p $TXTDIR/'2m_DPT'/'prob'/


mkdir -p $TXTDIR/'10m_Wind'/'UGRD'/
mkdir -p $TXTDIR/'10m_Wind'/'VGRD'/
mkdir -p $TXTDIR/'10m_Wind'/'WSPD'/'kts'/
mkdir -p $TXTDIR/'10m_Wind'/'WSPD'/'mph'/
mkdir -p $TXTDIR/'10m_Wind'/'prob'/'kts'/
mkdir -p $TXTDIR/'10m_Wind'/'prob'/'mph'/
mkdir -p $TXTDIR/'10m_Wind'/'derived'/'kts'/ #mnsd/
mkdir -p $TXTDIR/'10m_Wind'/'derived'/'mph'/
mkdir -p $TXTDIR/'10m_Wind'/'dtrm'/'kts'/

mkdir -p $TXTDIR/'950mb_TMP'/

mkdir -p $TXTDIR/'850mb_HGT'/'derived'/
mkdir -p $TXTDIR/'850mb_RH'/'derived'/
mkdir -p $TXTDIR/'850mb_TMP'/'derived'/
mkdir -p $TXTDIR/'850mb_DPT'/'derived'/
mkdir -p $TXTDIR/'850mb_Wind'/'UGRD'/
mkdir -p $TXTDIR/'850mb_Wind'/'VGRD'/
mkdir -p $TXTDIR/'850mb_Wind'/'WSPD'/
mkdir -p $TXTDIR/'850mb_Wind'/'derived'/
mkdir -p $TXTDIR/'850mb_Wind'/'dtrm'/


mkdir -p $TXTDIR/'700mb_HGT'/'derived'/
mkdir -p $TXTDIR/'700mb_RH'/'derived'/
mkdir -p $TXTDIR/'700mb_TMP'/'derived'/
mkdir -p $TXTDIR/'700mb_DPT'/'derived'/
mkdir -p $TXTDIR/'700mb_Wind'/'UGRD'/
mkdir -p $TXTDIR/'700mb_Wind'/'VGRD'/
mkdir -p $TXTDIR/'700mb_Wind'/'WSPD'/
mkdir -p $TXTDIR/'700mb_Wind'/'derived'/
mkdir -p $TXTDIR/'700mb_Wind'/'dtrm'/


mkdir -p $TXTDIR/'500mb_HGT'/'derived'/
mkdir -p $TXTDIR/'500mb_RH'/'derived'/
mkdir -p $TXTDIR/'500mb_TMP'/'derived'/
mkdir -p $TXTDIR/'500mb_Wind'/'UGRD'/
mkdir -p $TXTDIR/'500mb_Wind'/'VGRD'/
mkdir -p $TXTDIR/'500mb_Wind'/'WSPD'/
mkdir -p $TXTDIR/'500mb_Wind'/'derived'/
mkdir -p $TXTDIR/'500mb_Wind'/'dtrm'/


mkdir -p $TXTDIR/'300mb_HGT'/'derived'/
mkdir -p $TXTDIR/'300mb_RH'/'derived'/
mkdir -p $TXTDIR/'300mb_TMP'/'derived'/
mkdir -p $TXTDIR/'300mb_Wind'/'UGRD'/
mkdir -p $TXTDIR/'300mb_Wind'/'VGRD'/
mkdir -p $TXTDIR/'300mb_Wind'/'WSPD'/
mkdir -p $TXTDIR/'300mb_Wind'/'derived'/
mkdir -p $TXTDIR/'300mb_Wind'/'dtrm'/


mkdir -p $TXTDIR/'200mb_HGT'/'derived'/
mkdir -p $TXTDIR/'200mb_RH'/'derived'/
mkdir -p $TXTDIR/'200mb_TMP'/'derived'/
mkdir -p $TXTDIR/'200mb_Wind'/'UGRD'/
mkdir -p $TXTDIR/'200mb_Wind'/'VGRD'/
mkdir -p $TXTDIR/'200mb_Wind'/'WSPD'/
mkdir -p $TXTDIR/'200mb_Wind'/'derived'/
mkdir -p $TXTDIR/'200mb_Wind'/'dtrm'/

mkdir -p $TXTDIR/'Haines'/'Low'/'derived'
mkdir -p $TXTDIR/'Haines'/'Low'/'prob'
mkdir -p $TXTDIR/'Haines'/'Med'/'derived'
mkdir -p $TXTDIR/'Haines'/'Med'/'prob'
mkdir -p $TXTDIR/'Haines'/'High'/'derived'
mkdir -p $TXTDIR/'Haines'/'High'/'prob'




#FILE=../bash_dl/Data/sref_em.t03z.pgrb212.ctl.f03.grib2
for FILE in $DATADIR/*'.grib2'
do 
	# remove path
	FNAME=${FILE##*/}
	# remove file extension
	FNAME=${FNAME%\.grib2}
	
	# grab run
	RUN=${FNAME#*.}
	RUN=${RUN%%*.}
	RUN=${RUN:1:2}
	
	if [ "$RUN" != "$MCYCLE" ]
		then continue
	fi
		
	# grab model
	MODEL=${FNAME%%.*}
	MODEL=${MODEL#*_}
	
	# grab forecast hour
	FHR=${FNAME##*.}
	# remove leading non-digits
	N=${FHR##*[![:digit:]]}
	# remove leading zero
	N=${N#0}
	
	#APCP 3hr match string
	MATCH=":APCP:surface:$((N>0?N-3:N))-$N"
	
	#	 handle zero hour case
	if [ $N -gt 0 ]
	then
		MATCH="$MATCH hour acc fcst:"
	else
		MATCH="$MATCH day acc fcst:"
	fi
	
	if [ $N -eq 3 ] && [ "$MODEL" == "em" ] # pre-appended number due to dual in 'em' model grib files -- may need to change depending on if/how grib is subset  
		then
		MATCH="43:.*$MATCH"
	fi	
	#echo $MATCH
	
	#run wgrib2
	echo $FNAME
	$WGRIB -match "$MATCH" 		 $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'surface_APCP'/'3hr'/$FNAME.txt &
	
	$WGRIB -match ":RH:2 m "	 $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'2m_RH'/$FNAME.txt &
	$WGRIB -match ":TMP:2 m "	 $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'2m_TMP'/$FNAME.txt &
	$WGRIB -match ":DPT:2 m "	 $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'2m_DPT'/$FNAME.txt &
	
	$WGRIB -match ":UGRD:10 m " $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'10m_Wind'/'UGRD'/$FNAME.txt &
	$WGRIB -match ":VGRD:10 m " $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'10m_Wind'/'VGRD'/$FNAME.txt &
	
	$WGRIB -match ":TMP:950 mb"  $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'950mb_TMP'/$FNAME.txt &
	
	$WGRIB -match ":HGT:850 mb"  $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'850mb_HGT'/$FNAME.txt	&
	$WGRIB -match ":TMP:850 mb"  $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'850mb_TMP'/$FNAME.txt &
	$WGRIB -match ":DPT:850 mb"  $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'850mb_DPT'/$FNAME.txt &
	$WGRIB -match ":RH:850 mb"   $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'850mb_RH'/$FNAME.txt &
	$WGRIB -match ":UGRD:850 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'850mb_Wind'/'UGRD'/$FNAME.txt &
	$WGRIB -match ":VGRD:850 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'850mb_Wind'/'VGRD'/$FNAME.txt &

	$WGRIB -match ":HGT:700 mb"  $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'700mb_HGT'/$FNAME.txt	&
	$WGRIB -match ":TMP:700 mb"  $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'700mb_TMP'/$FNAME.txt &
	$WGRIB -match ":DPT:700 mb"  $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'700mb_DPT'/$FNAME.txt &
	$WGRIB -match ":RH:700 mb"   $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'700mb_RH'/$FNAME.txt  &
	$WGRIB -match ":UGRD:700 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'700mb_Wind'/'UGRD'/$FNAME.txt &
	$WGRIB -match ":VGRD:700 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'700mb_Wind'/'VGRD'/$FNAME.txt &
	
	$WGRIB -match ":HGT:500 mb"  $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'500mb_HGT'/$FNAME.txt	&
	$WGRIB -match ":TMP:500 mb"  $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'500mb_TMP'/$FNAME.txt &
	$WGRIB -match ":RH:500 mb"   $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'500mb_RH'/$FNAME.txt  &
	$WGRIB -match ":UGRD:500 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'500mb_Wind'/'UGRD'/$FNAME.txt &
	$WGRIB -match ":VGRD:500 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'500mb_Wind'/'VGRD'/$FNAME.txt &
	
	$WGRIB -match  ":HGT:300 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'300mb_HGT'/$FNAME.txt	&
	$WGRIB -match  ":TMP:300 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'300mb_TMP'/$FNAME.txt &
	$WGRIB -match   ":RH:300 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'300mb_RH'/$FNAME.txt  &
	$WGRIB -match ":UGRD:300 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'300mb_Wind'/'UGRD'/$FNAME.txt &
	$WGRIB -match ":VGRD:300 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'300mb_Wind'/'VGRD'/$FNAME.txt &
	
	$WGRIB -match  ":HGT:200 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'200mb_HGT'/$FNAME.txt	&
	$WGRIB -match  ":TMP:200 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'200mb_TMP'/$FNAME.txt &
	$WGRIB -match   ":RH:200 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'200mb_RH'/$FNAME.txt  &
	$WGRIB -match ":UGRD:200 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'200mb_Wind'/'UGRD'/$FNAME.txt &
	$WGRIB -match ":VGRD:200 mb" $FILE -inv /dev/null -csv - | awk -F "," '{print $7}' > $TXTDIR/'200mb_Wind'/'VGRD'/$FNAME.txt &
	
	wait
			
done