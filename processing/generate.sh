#!/bin/bash
# This script generates various derived quanities using the previously generated text files  

# Assumes valid date / run inputs
if [[ $# != 2 ]]; then
	echo "Usage: generate.sh DATE RUN"
	exit 1
fi

DATE="$1"
RUN=`printf "%02d" ${2#0}`

echo "Generating Derived Data..."
echo "#### stage 1 of 8 ####"
# Acumulated Precipitation
./programs/build/totalAcc data/fields/$DATE/surface_APCP/3hr/ $RUN data/fields/$DATE/surface_APCP/total/

./programs/build/xHrAcc data/fields/$DATE/surface_APCP/total/ $RUN 6 data/fields/$DATE/surface_APCP/6hr/   &
./programs/build/xHrAcc data/fields/$DATE/surface_APCP/total/ $RUN 12 data/fields/$DATE/surface_APCP/12hr/ &
./programs/build/xHrAcc data/fields/$DATE/surface_APCP/total/ $RUN 24 data/fields/$DATE/surface_APCP/24hr/ &

# Haines
./programs/build/haines data/fields/$DATE/950mb_TMP/ data/fields/$DATE/850mb_TMP/ data/fields/$DATE/850mb_DPT/ $RUN -L data/fields/$DATE/Haines/Low/  &
./programs/build/haines data/fields/$DATE/850mb_TMP/ data/fields/$DATE/700mb_TMP/ data/fields/$DATE/850mb_DPT/ $RUN -M data/fields/$DATE/Haines/Med/  &
./programs/build/haines data/fields/$DATE/700mb_TMP/ data/fields/$DATE/500mb_TMP/ data/fields/$DATE/700mb_DPT/ $RUN -H data/fields/$DATE/Haines/High/ &

wait

echo "#### stage 2 of 8 ####"
# Generate Stats
./programs/build/genStats data/fields/$DATE/850mb_HGT/ $RUN data/fields/$DATE/850mb_HGT/derived/ &
./programs/build/genStats data/fields/$DATE/850mb_RH/  $RUN data/fields/$DATE/850mb_RH/derived/  &
./programs/build/genStats data/fields/$DATE/850mb_TMP/ $RUN data/fields/$DATE/850mb_TMP/derived/ &

./programs/build/genStats data/fields/$DATE/700mb_HGT/ $RUN data/fields/$DATE/700mb_HGT/derived/ &
./programs/build/genStats data/fields/$DATE/700mb_RH/  $RUN data/fields/$DATE/700mb_RH/derived/  &
./programs/build/genStats data/fields/$DATE/700mb_TMP/ $RUN data/fields/$DATE/700mb_TMP/derived/ &

./programs/build/genStats data/fields/$DATE/500mb_HGT/ $RUN data/fields/$DATE/500mb_HGT/derived/ &
./programs/build/genStats data/fields/$DATE/500mb_RH/  $RUN data/fields/$DATE/500mb_RH/derived/  &
./programs/build/genStats data/fields/$DATE/500mb_TMP/ $RUN data/fields/$DATE/500mb_TMP/derived/ &

./programs/build/genStats data/fields/$DATE/300mb_HGT/ $RUN data/fields/$DATE/300mb_HGT/derived/ &
./programs/build/genStats data/fields/$DATE/300mb_RH/  $RUN data/fields/$DATE/300mb_RH/derived/  &
./programs/build/genStats data/fields/$DATE/300mb_TMP/ $RUN data/fields/$DATE/300mb_TMP/derived/ &

./programs/build/genStats data/fields/$DATE/200mb_HGT/ $RUN data/fields/$DATE/200mb_HGT/derived/ &
./programs/build/genStats data/fields/$DATE/200mb_RH/  $RUN data/fields/$DATE/200mb_RH/derived/  &
./programs/build/genStats data/fields/$DATE/200mb_TMP/ $RUN data/fields/$DATE/200mb_TMP/derived/ &

./programs/build/genStats data/fields/$DATE/2m_RH/  $RUN data/fields/$DATE/2m_RH/derived/        &
./programs/build/genStats data/fields/$DATE/2m_TMP/ $RUN data/fields/$DATE/2m_TMP/derived/       &
./programs/build/genStats data/fields/$DATE/2m_DPT/ $RUN data/fields/$DATE/2m_DPT/derived/       &

wait

echo "#### stage 3 of 8 ####"
./programs/build/genStats data/fields/$DATE/surface_APCP/3hr/  $RUN -h 3  data/fields/$DATE/surface_APCP/3hr/derived/  &
./programs/build/genStats data/fields/$DATE/surface_APCP/6hr/  $RUN -h 6  data/fields/$DATE/surface_APCP/6hr/derived/  &
./programs/build/genStats data/fields/$DATE/surface_APCP/12hr/ $RUN -h 12 data/fields/$DATE/surface_APCP/12hr/derived/ &
./programs/build/genStats data/fields/$DATE/surface_APCP/24hr/ $RUN -h 24 data/fields/$DATE/surface_APCP/24hr/derived/ &

./programs/build/genStats data/fields/$DATE/Haines/Low/  $RUN data/fields/$DATE/Haines/Low/derived/  &
./programs/build/genStats data/fields/$DATE/Haines/Med/  $RUN data/fields/$DATE/Haines/Med/derived/  &
./programs/build/genStats data/fields/$DATE/Haines/High/ $RUN data/fields/$DATE/Haines/High/derived/ &

wait

echo "#### stage 4 of 8 ####"
# Generate Mean Winds
./programs/build/meanWind data/fields/$DATE/850mb_Wind/UGRD/ data/fields/$DATE/850mb_Wind/VGRD/ $RUN data/fields/$DATE/850mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/700mb_Wind/UGRD/ data/fields/$DATE/700mb_Wind/VGRD/ $RUN data/fields/$DATE/700mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/500mb_Wind/UGRD/ data/fields/$DATE/500mb_Wind/VGRD/ $RUN data/fields/$DATE/500mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/300mb_Wind/UGRD/ data/fields/$DATE/300mb_Wind/VGRD/ $RUN data/fields/$DATE/300mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/200mb_Wind/UGRD/ data/fields/$DATE/200mb_Wind/VGRD/ $RUN data/fields/$DATE/200mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/200mb_Wind/UGRD/ data/fields/$DATE/200mb_Wind/VGRD/ $RUN data/fields/$DATE/200mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/10m_Wind/UGRD/ 	 data/fields/$DATE/10m_Wind/VGRD/ 	$RUN data/fields/$DATE/10m_Wind/derived/kts/ &

# Wind Speed per Member (for probabilities)
./programs/build/perMemberWindSpeed data/fields/$DATE/10m_Wind/UGRD/ data/fields/$DATE/10m_Wind/VGRD/ $RUN data/fields/$DATE/10m_Wind/WSPD/mph/ -mph &
./programs/build/perMemberWindSpeed data/fields/$DATE/10m_Wind/UGRD/ data/fields/$DATE/10m_Wind/VGRD/ $RUN data/fields/$DATE/10m_Wind/WSPD/kts/ -kt &
# Note: for production would want to handle generation of per-memeber winds, mean, standard deviation, etc. smarter (e.g. integrate standard deviation calcuation into meanWinds)

# Deterministic Winds
MODEL=arw ## before 10/21/2015 -- MODEL=em
./programs/build/dtrmWind data/fields/$DATE/850mb_Wind/UGRD/ data/fields/$DATE/850mb_Wind/VGRD/ $RUN $MODEL ctl data/fields/$DATE/850mb_Wind/dtrm/kts/ -kt &
./programs/build/dtrmWind data/fields/$DATE/700mb_Wind/UGRD/ data/fields/$DATE/700mb_Wind/VGRD/ $RUN $MODEL ctl data/fields/$DATE/700mb_Wind/dtrm/kts/ -kt &
./programs/build/dtrmWind data/fields/$DATE/500mb_Wind/UGRD/ data/fields/$DATE/500mb_Wind/VGRD/ $RUN $MODEL ctl data/fields/$DATE/500mb_Wind/dtrm/kts/ -kt &
./programs/build/dtrmWind data/fields/$DATE/300mb_Wind/UGRD/ data/fields/$DATE/300mb_Wind/VGRD/ $RUN $MODEL ctl data/fields/$DATE/300mb_Wind/dtrm/kts/ -kt &
./programs/build/dtrmWind data/fields/$DATE/200mb_Wind/UGRD/ data/fields/$DATE/200mb_Wind/VGRD/ $RUN $MODEL ctl data/fields/$DATE/200mb_Wind/dtrm/kts/ -kt &
./programs/build/dtrmWind data/fields/$DATE/10m_Wind/UGRD/ 	 data/fields/$DATE/10m_Wind/VGRD/   $RUN $MODEL ctl data/fields/$DATE/10m_Wind/dtrm/kts/   -kt &

wait

echo "#### stage 5 of 8 ####"
# Probabilities
./programs/build/genProb data/fields/$DATE/2m_RH/ $RUN -le 10 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $RUN -le 15 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $RUN -le 20 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $RUN -le 25 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $RUN -le 30 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $RUN -le 35 data/fields/$DATE/2m_RH/prob/ &

./programs/build/genProb data/fields/$DATE/2m_RH/ $RUN -ge 20 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $RUN -ge 25 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $RUN -ge 30 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $RUN -ge 40 data/fields/$DATE/2m_RH/prob/ &

./programs/build/genProb data/fields/$DATE/2m_DPT/ $RUN -ge 272.0388888889 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_DPT/ $RUN -ge 274.8166666667 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_DPT/ $RUN -ge 277.5944444444 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_DPT/ $RUN -ge 280.3722222222 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_DPT/ $RUN -ge 283.15 		  data/fields/$DATE/2m_RH/prob/ &

wait

echo "#### stage 6 of 8 ####"
./programs/build/genProb data/fields/$DATE/2m_TMP/ $RUN -ge 288.706 data/fields/$DATE/2m_TMP/prob/ &

./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/kts/ $RUN -ge 18 data/fields/$DATE/10m_Wind/prob/kts/ &
./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/mph/ $RUN -ge 10 data/fields/$DATE/10m_Wind/prob/mph/ &
./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/mph/ $RUN -ge 15 data/fields/$DATE/10m_Wind/prob/mph/ &
./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/mph/ $RUN -ge 20 data/fields/$DATE/10m_Wind/prob/mph/ &
./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/mph/ $RUN -ge 30 data/fields/$DATE/10m_Wind/prob/mph/ &

wait

echo "#### stage 7 of 8 ####"
# note conversion: important thesholds are in inches but data is in kg/m^2 (1 in = 25.4 kg/m^2)
./programs/build/genProb data/fields/$DATE/surface_APCP/3hr/ $RUN -ge 0.254 -h 3 data/fields/$DATE/surface_APCP/3hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/3hr/ $RUN -ge 1.270 -h 3 data/fields/$DATE/surface_APCP/3hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/3hr/ $RUN -ge 2.540 -h 3 data/fields/$DATE/surface_APCP/3hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/3hr/ $RUN -ge 6.350 -h 3 data/fields/$DATE/surface_APCP/3hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/3hr/ $RUN -ge 12.70 -h 3 data/fields/$DATE/surface_APCP/3hr/prob/ &

./programs/build/genProb data/fields/$DATE/surface_APCP/6hr/ $RUN -ge 0.254 -h 6 data/fields/$DATE/surface_APCP/6hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/6hr/ $RUN -ge 1.270 -h 6 data/fields/$DATE/surface_APCP/6hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/6hr/ $RUN -ge 2.540 -h 6 data/fields/$DATE/surface_APCP/6hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/6hr/ $RUN -ge 6.350 -h 6 data/fields/$DATE/surface_APCP/6hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/6hr/ $RUN -ge 12.70 -h 6 data/fields/$DATE/surface_APCP/6hr/prob/ &

./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $RUN -ge 0.254 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $RUN -ge 1.270 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $RUN -ge 2.540 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $RUN -ge 6.350 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $RUN -ge 12.70 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/ &

./programs/build/genProb data/fields/$DATE/surface_APCP/24hr/ $RUN -ge 0.254 -h 24 data/fields/$DATE/surface_APCP/24hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/24hr/ $RUN -ge 1.270 -h 24 data/fields/$DATE/surface_APCP/24hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/24hr/ $RUN -ge 2.540 -h 24 data/fields/$DATE/surface_APCP/24hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/24hr/ $RUN -ge 6.350 -h 24 data/fields/$DATE/surface_APCP/24hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/24hr/ $RUN -ge 12.70 -h 24 data/fields/$DATE/surface_APCP/24hr/prob/ &

wait


echo "#### stage 8 of 8 ####"
./programs/build/genProb data/fields/$DATE/Haines/High/ $RUN -ge 5 data/fields/$DATE/Haines/High/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/High/ $RUN -ge 6 data/fields/$DATE/Haines/High/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/High/ $RUN -le 4 data/fields/$DATE/Haines/High/prob/ &

./programs/build/genProb data/fields/$DATE/Haines/Med/ $RUN -ge 5 data/fields/$DATE/Haines/Med/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/Med/ $RUN -ge 6 data/fields/$DATE/Haines/Med/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/Med/ $RUN -le 4 data/fields/$DATE/Haines/Med/prob/ &

./programs/build/genProb data/fields/$DATE/Haines/Low/ $RUN -ge 5 data/fields/$DATE/Haines/Low/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/Low/ $RUN -ge 6 data/fields/$DATE/Haines/Low/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/Low/ $RUN -le 4 data/fields/$DATE/Haines/Low/prob/ &

wait

echo "completed."

