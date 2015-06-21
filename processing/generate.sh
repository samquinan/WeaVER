#!/bin/bash

if [[ $# != 2 ]]; then
	echo "Usage: generate.sh DATE MCYCLE"
	exit 1
fi

DATE="$1"
MCYCLE=`printf "%02d" ${2#0}`

# MCYCLE="21"
# DATE="20140429"


# APCP
./programs/build/totalAcc data/fields/$DATE/surface_APCP/3hr/ $MCYCLE data/fields/$DATE/surface_APCP/total/   &
wait
./programs/build/xHrAcc data/fields/$DATE/surface_APCP/total/ $MCYCLE 6 data/fields/$DATE/surface_APCP/6hr/   &
./programs/build/xHrAcc data/fields/$DATE/surface_APCP/total/ $MCYCLE 12 data/fields/$DATE/surface_APCP/12hr/ &
./programs/build/xHrAcc data/fields/$DATE/surface_APCP/total/ $MCYCLE 24 data/fields/$DATE/surface_APCP/24hr/ &


# Haines
./programs/build/haines data/fields/$DATE/950mb_TMP/ data/fields/$DATE/850mb_TMP/ data/fields/$DATE/850mb_DPT/ $MCYCLE -L data/fields/$DATE/Haines/Low/  &
./programs/build/haines data/fields/$DATE/850mb_TMP/ data/fields/$DATE/700mb_TMP/ data/fields/$DATE/850mb_DPT/ $MCYCLE -M data/fields/$DATE/Haines/Med/  &
./programs/build/haines data/fields/$DATE/700mb_TMP/ data/fields/$DATE/500mb_TMP/ data/fields/$DATE/700mb_DPT/ $MCYCLE -H data/fields/$DATE/Haines/High/ &

wait

# Generate Stats
./programs/build/genStats data/fields/$DATE/850mb_HGT/ $MCYCLE data/fields/$DATE/850mb_HGT/derived/ &
./programs/build/genStats data/fields/$DATE/850mb_RH/  $MCYCLE data/fields/$DATE/850mb_RH/derived/  &
./programs/build/genStats data/fields/$DATE/850mb_TMP/ $MCYCLE data/fields/$DATE/850mb_TMP/derived/ &

./programs/build/genStats data/fields/$DATE/700mb_HGT/ $MCYCLE data/fields/$DATE/700mb_HGT/derived/ &
./programs/build/genStats data/fields/$DATE/700mb_RH/  $MCYCLE data/fields/$DATE/700mb_RH/derived/  &
./programs/build/genStats data/fields/$DATE/700mb_TMP/ $MCYCLE data/fields/$DATE/700mb_TMP/derived/ &
                                                                                                    
./programs/build/genStats data/fields/$DATE/500mb_HGT/ $MCYCLE data/fields/$DATE/500mb_HGT/derived/ &
./programs/build/genStats data/fields/$DATE/500mb_RH/  $MCYCLE data/fields/$DATE/500mb_RH/derived/  &
./programs/build/genStats data/fields/$DATE/500mb_TMP/ $MCYCLE data/fields/$DATE/500mb_TMP/derived/ &

./programs/build/genStats data/fields/$DATE/300mb_HGT/ $MCYCLE data/fields/$DATE/300mb_HGT/derived/ &
./programs/build/genStats data/fields/$DATE/300mb_RH/  $MCYCLE data/fields/$DATE/300mb_RH/derived/  &
./programs/build/genStats data/fields/$DATE/300mb_TMP/ $MCYCLE data/fields/$DATE/300mb_TMP/derived/ &

./programs/build/genStats data/fields/$DATE/200mb_HGT/ $MCYCLE data/fields/$DATE/200mb_HGT/derived/ &
./programs/build/genStats data/fields/$DATE/200mb_RH/  $MCYCLE data/fields/$DATE/200mb_RH/derived/  &
./programs/build/genStats data/fields/$DATE/200mb_TMP/ $MCYCLE data/fields/$DATE/200mb_TMP/derived/ &

./programs/build/genStats data/fields/$DATE/2m_RH/  $MCYCLE data/fields/$DATE/2m_RH/derived/        &
./programs/build/genStats data/fields/$DATE/2m_TMP/ $MCYCLE data/fields/$DATE/2m_TMP/derived/       &
./programs/build/genStats data/fields/$DATE/2m_DPT/ $MCYCLE data/fields/$DATE/2m_DPT/derived/       &


wait

./programs/build/genStats data/fields/$DATE/surface_APCP/3hr/  $MCYCLE -h 3  data/fields/$DATE/surface_APCP/3hr/derived/  &
./programs/build/genStats data/fields/$DATE/surface_APCP/6hr/  $MCYCLE -h 6  data/fields/$DATE/surface_APCP/6hr/derived/  &
./programs/build/genStats data/fields/$DATE/surface_APCP/12hr/ $MCYCLE -h 12 data/fields/$DATE/surface_APCP/12hr/derived/ &
./programs/build/genStats data/fields/$DATE/surface_APCP/24hr/ $MCYCLE -h 24 data/fields/$DATE/surface_APCP/24hr/derived/ &

./programs/build/genStats data/fields/$DATE/Haines/Low/  $MCYCLE data/fields/$DATE/Haines/Low/derived/  &
./programs/build/genStats data/fields/$DATE/Haines/Med/  $MCYCLE data/fields/$DATE/Haines/Med/derived/  &
./programs/build/genStats data/fields/$DATE/Haines/High/ $MCYCLE data/fields/$DATE/Haines/High/derived/ &

wait

# WIND
./programs/build/meanWind data/fields/$DATE/850mb_Wind/UGRD/ data/fields/$DATE/850mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/850mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/700mb_Wind/UGRD/ data/fields/$DATE/700mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/700mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/500mb_Wind/UGRD/ data/fields/$DATE/500mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/500mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/300mb_Wind/UGRD/ data/fields/$DATE/300mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/300mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/200mb_Wind/UGRD/ data/fields/$DATE/200mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/200mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/200mb_Wind/UGRD/ data/fields/$DATE/200mb_Wind/VGRD/ $MCYCLE data/fields/$DATE/200mb_Wind/derived/   &
./programs/build/meanWind data/fields/$DATE/10m_Wind/UGRD/ 	 data/fields/$DATE/10m_Wind/VGRD/ 	$MCYCLE data/fields/$DATE/10m_Wind/derived/kts/ &

# Wind Speed per Member (for probabilities)
./programs/build/perMemberWindSpeed data/fields/$DATE/10m_Wind/UGRD/ data/fields/$DATE/10m_Wind/VGRD/ $MCYCLE data/fields/$DATE/10m_Wind/WSPD/mph/ -mph &
./programs/build/perMemberWindSpeed data/fields/$DATE/10m_Wind/UGRD/ data/fields/$DATE/10m_Wind/VGRD/ $MCYCLE data/fields/$DATE/10m_Wind/WSPD/kts/ -kt &
# will want to handle generation of per-memeber winds, mean, standard deviation, etc. smarter (e.g. integrate standard deviation calcuation into meanWinds)
# ./programs/build/genStats data/fields/$DATE/10m_Wind/WSPD/kts/ data/fields/$DATE/10m_Wind/derived/kts/mnsd

# deterministic
./programs/build/dtrmWind data/fields/$DATE/850mb_Wind/UGRD/ data/fields/$DATE/850mb_Wind/VGRD/ $MCYCLE em ctl data/fields/$DATE/850mb_Wind/dtrm/ -kt &
./programs/build/dtrmWind data/fields/$DATE/700mb_Wind/UGRD/ data/fields/$DATE/700mb_Wind/VGRD/ $MCYCLE em ctl data/fields/$DATE/700mb_Wind/dtrm/ -kt &
./programs/build/dtrmWind data/fields/$DATE/500mb_Wind/UGRD/ data/fields/$DATE/500mb_Wind/VGRD/ $MCYCLE em ctl data/fields/$DATE/500mb_Wind/dtrm/ -kt &
./programs/build/dtrmWind data/fields/$DATE/300mb_Wind/UGRD/ data/fields/$DATE/300mb_Wind/VGRD/ $MCYCLE em ctl data/fields/$DATE/300mb_Wind/dtrm/ -kt &
./programs/build/dtrmWind data/fields/$DATE/200mb_Wind/UGRD/ data/fields/$DATE/200mb_Wind/VGRD/ $MCYCLE em ctl data/fields/$DATE/200mb_Wind/dtrm/ -kt &
./programs/build/dtrmWind data/fields/$DATE/10m_Wind/UGRD/ 	 data/fields/$DATE/10m_Wind/VGRD/   $MCYCLE em ctl data/fields/$DATE/10m_Wind/dtrm/   -kt &

wait

# Probabilities
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -le 10 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -le 15 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -le 20 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -le 25 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -le 30 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -le 35 data/fields/$DATE/2m_RH/prob/ &

./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -ge 20 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -ge 25 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -ge 30 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_RH/ $MCYCLE -ge 40 data/fields/$DATE/2m_RH/prob/ &

./programs/build/genProb data/fields/$DATE/2m_DPT/ $MCYCLE -ge 272.0388888889 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_DPT/ $MCYCLE -ge 274.8166666667 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_DPT/ $MCYCLE -ge 277.5944444444 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_DPT/ $MCYCLE -ge 280.3722222222 data/fields/$DATE/2m_RH/prob/ &
./programs/build/genProb data/fields/$DATE/2m_DPT/ $MCYCLE -ge 283.15 		  data/fields/$DATE/2m_RH/prob/ &

wait

./programs/build/genProb data/fields/$DATE/2m_TMP/ $MCYCLE -ge 288.706 data/fields/$DATE/2m_TMP/prob/ &

./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/kts/ $MCYCLE -ge 18 data/fields/$DATE/10m_Wind/prob/kts/ &
./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/mph/ $MCYCLE -ge 10 data/fields/$DATE/10m_Wind/prob/mph/ &
./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/mph/ $MCYCLE -ge 15 data/fields/$DATE/10m_Wind/prob/mph/ &
./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/mph/ $MCYCLE -ge 20 data/fields/$DATE/10m_Wind/prob/mph/ &
./programs/build/genProb data/fields/$DATE/10m_Wind/WSPD/mph/ $MCYCLE -ge 30 data/fields/$DATE/10m_Wind/prob/mph/ &

wait

# conversion: x in * 25.4 kg/m^2 
./programs/build/genProb data/fields/$DATE/surface_APCP/3hr/ $MCYCLE -ge 0.254 -h 3 data/fields/$DATE/surface_APCP/3hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/3hr/ $MCYCLE -ge 1.270 -h 3 data/fields/$DATE/surface_APCP/3hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/3hr/ $MCYCLE -ge 2.540 -h 3 data/fields/$DATE/surface_APCP/3hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/3hr/ $MCYCLE -ge 6.350 -h 3 data/fields/$DATE/surface_APCP/3hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/3hr/ $MCYCLE -ge 12.70 -h 3 data/fields/$DATE/surface_APCP/3hr/prob/ &

./programs/build/genProb data/fields/$DATE/surface_APCP/6hr/ $MCYCLE -ge 0.254 -h 6 data/fields/$DATE/surface_APCP/6hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/6hr/ $MCYCLE -ge 1.270 -h 6 data/fields/$DATE/surface_APCP/6hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/6hr/ $MCYCLE -ge 2.540 -h 6 data/fields/$DATE/surface_APCP/6hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/6hr/ $MCYCLE -ge 6.350 -h 6 data/fields/$DATE/surface_APCP/6hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/6hr/ $MCYCLE -ge 12.70 -h 6 data/fields/$DATE/surface_APCP/6hr/prob/ &

./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $MCYCLE -ge 0.254 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $MCYCLE -ge 1.270 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $MCYCLE -ge 2.540 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $MCYCLE -ge 6.350 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $MCYCLE -ge 12.70 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/ &

./programs/build/genProb data/fields/$DATE/surface_APCP/24hr/ $MCYCLE -ge 0.254 -h 24 data/fields/$DATE/surface_APCP/24hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/24hr/ $MCYCLE -ge 1.270 -h 24 data/fields/$DATE/surface_APCP/24hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/24hr/ $MCYCLE -ge 2.540 -h 24 data/fields/$DATE/surface_APCP/24hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/24hr/ $MCYCLE -ge 6.350 -h 24 data/fields/$DATE/surface_APCP/24hr/prob/ &
./programs/build/genProb data/fields/$DATE/surface_APCP/24hr/ $MCYCLE -ge 12.70 -h 24 data/fields/$DATE/surface_APCP/24hr/prob/ &

wait

./programs/build/genProb data/fields/$DATE/Haines/High/ $MCYCLE -ge 5 data/fields/$DATE/Haines/High/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/High/ $MCYCLE -ge 6 data/fields/$DATE/Haines/High/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/High/ $MCYCLE -le 4 data/fields/$DATE/Haines/High/prob/ &

./programs/build/genProb data/fields/$DATE/Haines/Med/ $MCYCLE -ge 5 data/fields/$DATE/Haines/Med/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/Med/ $MCYCLE -ge 6 data/fields/$DATE/Haines/Med/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/Med/ $MCYCLE -le 4 data/fields/$DATE/Haines/Med/prob/ &

./programs/build/genProb data/fields/$DATE/Haines/Low/ $MCYCLE -ge 5 data/fields/$DATE/Haines/Low/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/Low/ $MCYCLE -ge 6 data/fields/$DATE/Haines/Low/prob/ &
./programs/build/genProb data/fields/$DATE/Haines/Low/ $MCYCLE -le 4 data/fields/$DATE/Haines/Low/prob/ &

wait

# ./programs/build/prob2   data/fields/$DATE/Haines/High/ $MCYCLE -ge 3 -le 4 data/fields/$DATE/Haines/High/prob/
# ./programs/build/genProb data/fields/$DATE/surface_APCP/12hr/ $MCYCLE -le 2.54 -h 12 data/fields/$DATE/surface_APCP/12hr/prob/

