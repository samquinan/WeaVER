#!/bin/bash
if [[ $# != 2 ]]; then
	echo "Usage: genCBP.sh DATE RUN"
	exit 1
fi

DATE="$1"
RUN=`printf "%02d" ${2#0}`

# create output directories
# note: reduced for demo -- enable by uncommenting here and in the loadData() routine in WeaVER's EnsembleView.pde
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5100
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5160
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5220
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5280
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5340
mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5400
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5520
mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5580
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5640
mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5700
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5760
mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5820
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5880
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_HGT/5940

mkdir -p ./data/cbp/$DATE/$RUN/2m_RH/10
mkdir -p ./data/cbp/$DATE/$RUN/2m_RH/20
mkdir -p ./data/cbp/$DATE/$RUN/2m_RH/30

mkdir -p ./data/cbp/$DATE/$RUN/2m_TMP/32F 
mkdir -p ./data/cbp/$DATE/$RUN/2m_TMP/60F 

mkdir -p ./data/cbp/$DATE/$RUN/10m_WSPD/18kts

mkdir -p ./data/cbp/$DATE/$RUN/Haines/High/5

mkdir -p ./data/cbp/$DATE/$RUN/surface_APCP/3hr/0_254/
mkdir -p ./data/cbp/$DATE/$RUN/surface_APCP/3hr/2_54/


# run cbp routines
echo "running contour boxplot analysis..."

# ./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5100 ./data/cbp/$DATE/$RUN/500mb_HGT/5100/ &
# ./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5160 ./data/cbp/$DATE/$RUN/500mb_HGT/5160/ &
# ./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5220 ./data/cbp/$DATE/$RUN/500mb_HGT/5220/ &
# ./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5280 ./data/cbp/$DATE/$RUN/500mb_HGT/5280/ &
# ./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5340 ./data/cbp/$DATE/$RUN/500mb_HGT/5340/ &
./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5400 ./data/cbp/$DATE/$RUN/500mb_HGT/5400/ &
# ./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5520 ./data/cbp/$DATE/$RUN/500mb_HGT/5520/ &
./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5580 ./data/cbp/$DATE/$RUN/500mb_HGT/5580/ &
# ./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5640 ./data/cbp/$DATE/$RUN/500mb_HGT/5640/ &
./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5700 ./data/cbp/$DATE/$RUN/500mb_HGT/5700/ &
# ./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5760 ./data/cbp/$DATE/$RUN/500mb_HGT/5760/ &
./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5820 ./data/cbp/$DATE/$RUN/500mb_HGT/5820/ &
# ./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5880 ./data/cbp/$DATE/$RUN/500mb_HGT/5880/ &
# ./cbp/build/CBD ./data/fields/$DATE/500mb_HGT/ 212 $RUN 5940 ./data/cbp/$DATE/$RUN/500mb_HGT/5940/ &

./cbp/build/CBD ./data/fields/$DATE/2m_RH/ 212 $RUN 10 ./data/cbp/$DATE/$RUN/2m_RH/10/ &
./cbp/build/CBD ./data/fields/$DATE/2m_RH/ 212 $RUN 20 ./data/cbp/$DATE/$RUN/2m_RH/20/ &
./cbp/build/CBD ./data/fields/$DATE/2m_RH/ 212 $RUN 30 ./data/cbp/$DATE/$RUN/2m_RH/30/ &

./cbp/build/CBD ./data/fields/$DATE/2m_TMP/ 212 $RUN 273.15 	./data/cbp/$DATE/$RUN/2m_TMP/32F/ &
./cbp/build/CBD ./data/fields/$DATE/2m_TMP/ 212 $RUN 288.705556 ./data/cbp/$DATE/$RUN/2m_TMP/60F/ &

./cbp/build/CBD ./data/fields/$DATE/10m_Wind/WSPD/kts/ 212 $RUN 18 ./data/cbp/$DATE/$RUN/10m_WSPD/18kts/ &

./cbp/build/CBD ./data/fields/$DATE/Haines/High/ 212 $RUN 4.5 ./data/cbp/$DATE/$RUN/Haines/High/5/ &

# ./cbp/build/CBD ./data/fields/$DATE/surface_APCP/3hr/  212 $RUN 0.254 ./data/cbp/$DATE/$RUN/surface_APCP/3hr/0_254/  &
# ./cbp/build/CBD ./data/fields/$DATE/surface_APCP/3hr/  212 $RUN 2.54  ./data/cbp/$DATE/$RUN/surface_APCP/3hr/2_54/  &

wait
echo "contour boxplot analysis completed."

# mkdir -p ./data/cbp/$DATE/$RUN/500mb_TMP/258_15/
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_TMP/253_15/
# mkdir -p ./data/cbp/$DATE/$RUN/500mb_TMP/248_15/
# mkdir -p ./data/cbp/$DATE/$RUN/700mb_TMP/283_15/
# mkdir -p ./data/cbp/$DATE/$RUN/700mb_TMP/288_15/

# ./cbp/build/CBD ./data/fields/$DATE/500mb_TMP/ 212 $RUN 258.15 ./data/cbp/$DATE/$RUN/500mb_TMP/258_15/
# ./cbp/build/CBD ./data/fields/$DATE/500mb_TMP/ 212 $RUN 253.15 ./data/cbp/$DATE/$RUN/500mb_TMP/253_15/
# ./cbp/build/CBD ./data/fields/$DATE/500mb_TMP/ 212 $RUN 248.15 ./data/cbp/$DATE/$RUN/500mb_TMP/248_15/
# ./cbp/build/CBD ./data/fields/$DATE/700mb_TMP/ 212 $RUN 283.15 ./data/cbp/$DATE/$RUN/700mb_TMP/283_15/
# ./cbp/build/CBD ./data/fields/$DATE/700mb_TMP/ 212 $RUN 288.15 ./data/cbp/$DATE/$RUN/700mb_TMP/288_15/
