#!/bin/bash

if [[ $# != 2 ]]; then
	echo "Usage: generate.sh DATE MCYCLE"
	exit 1
fi

DATE="$1"
MCYCLE=`printf "%02d" ${2#0}`

# MCYCLE="21"
# DATE="20140429"


# Wind Speed per Member
./programs/build/perMemberWindSpeed data/fields/$DATE/10m_Wind/UGRD/ data/fields/$DATE/10m_Wind/VGRD/ $MCYCLE data/fields/$DATE/10m_Wind/WSPD/ -mph

# APCP
./programs/build/totalAcc data/fields/$DATE/surface_APCP/3hr/ $MCYCLE data/fields/$DATE/surface_APCP/total/
./programs/build/xHrAcc data/fields/$DATE/surface_APCP/total/ $MCYCLE 12 data/fields/$DATE/surface_APCP/12hr/

# Generate Stats
./programs/build/genStats data/fields/$DATE/850mb_HGT/ $MCYCLE data/fields/$DATE/850mb_HGT/derived/
./programs/build/genStats data/fields/$DATE/850mb_RH/  $MCYCLE data/fields/$DATE/850mb_RH/derived/
./programs/build/genStats data/fields/$DATE/850mb_TMP/ $MCYCLE data/fields/$DATE/850mb_TMP/derived/

./programs/build/genStats data/fields/$DATE/700mb_HGT/ $MCYCLE data/fields/$DATE/700mb_HGT/derived/
./programs/build/genStats data/fields/$DATE/700mb_RH/  $MCYCLE data/fields/$DATE/700mb_RH/derived/
./programs/build/genStats data/fields/$DATE/700mb_TMP/ $MCYCLE data/fields/$DATE/700mb_TMP/derived/

./programs/build/genStats data/fields/$DATE/500mb_HGT/ $MCYCLE data/fields/$DATE/500mb_HGT/derived/
./programs/build/genStats data/fields/$DATE/500mb_RH/  $MCYCLE data/fields/$DATE/500mb_RH/derived/
./programs/build/genStats data/fields/$DATE/500mb_TMP/ $MCYCLE data/fields/$DATE/500mb_TMP/derived/

./programs/build/genStats data/fields/$DATE/300mb_HGT/ $MCYCLE data/fields/$DATE/300mb_HGT/derived/
./programs/build/genStats data/fields/$DATE/300mb_RH/  $MCYCLE data/fields/$DATE/300mb_RH/derived/
./programs/build/genStats data/fields/$DATE/300mb_TMP/ $MCYCLE data/fields/$DATE/300mb_TMP/derived/

./programs/build/genStats data/fields/$DATE/200mb_HGT/ $MCYCLE data/fields/$DATE/200mb_HGT/derived/
./programs/build/genStats data/fields/$DATE/200mb_RH/  $MCYCLE data/fields/$DATE/200mb_RH/derived/
./programs/build/genStats data/fields/$DATE/200mb_TMP/ $MCYCLE data/fields/$DATE/200mb_TMP/derived/

# TODO FIX WIND
./programs/build/meanWind data/fields/$DATE/850mb_Wind/UGRD/ data/fields/$DATE/850mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/850mb_Wind/derived/
./programs/build/meanWind data/fields/$DATE/700mb_Wind/UGRD/ data/fields/$DATE/700mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/700mb_Wind/derived/
./programs/build/meanWind data/fields/$DATE/500mb_Wind/UGRD/ data/fields/$DATE/500mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/500mb_Wind/derived/
./programs/build/meanWind data/fields/$DATE/300mb_Wind/UGRD/ data/fields/$DATE/300mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/300mb_Wind/derived/
./programs/build/meanWind data/fields/$DATE/200mb_Wind/UGRD/ data/fields/$DATE/200mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/200mb_Wind/derived/


# Probabilities
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -le 15 data/fields/$DATE/2m_RH/prob/
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -ge 30 data/fields/$DATE/2m_RH/prob/

./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/ $MCYCLE -ge 20 data/fields/$DATE/10m_Wind/prob/

./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $MCYCLE -le 0.254 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/

# ./programs/build/genProb data/fields/$DATE/2m_TMP/ $MCYCLE -ge 288.706 data/fields/$DATE/2m_TMP/prob/
# ./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $MCYCLE -le 2.54 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/

