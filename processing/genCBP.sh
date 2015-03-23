#!/bin/bash
if [[ $# != 2 ]]; then
	echo "Usage: genCBP.sh DATE MCYCLE"
	exit 1
fi

DATE="$1"
MCYCLE=`printf "%02d" ${2#0}`

# create output directories
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5100
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5160
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5220
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5280
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5340
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5400
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5520
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5580
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5640
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5700
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5760
mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5820

mkdir -p ./data/cbp/$DATE/$MCYCLE/2m_RH/10
mkdir -p ./data/cbp/$DATE/$MCYCLE/2m_RH/20
mkdir -p ./data/cbp/$DATE/$MCYCLE/2m_RH/30

mkdir -p ./data/cbp/$DATE/$MCYCLE/2m_TMP/32F 
mkdir -p ./data/cbp/$DATE/$MCYCLE/2m_TMP/60F 

mkdir -p ./data/cbp/$DATE/$MCYCLE/10m_WSPD/18kts

# mkdir -p ./data/cbp/$DATE/$MCYCLE/Haines/Low/5
# mkdir -p ./data/cbp/$DATE/$MCYCLE/Haines/Med/5
mkdir -p ./data/cbp/$DATE/$MCYCLE/Haines/High/5

mkdir -p ./data/cbp/$DATE/$MCYCLE/surface_APCP/3hr/0_254/
mkdir -p ./data/cbp/$DATE/$MCYCLE/surface_APCP/3hr/2_54/


# run cbp routines

./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5100 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5100/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5160 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5160/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5220 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5220/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5280 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5280/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5340 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5340/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5400 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5400/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5520 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5520/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5580 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5580/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5640 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5640/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5700 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5700/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5760 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5760/ &
./cbp/build/main ./data/fields/$DATE/500mb_HGT/ 212 $MCYCLE 5820 ./data/cbp/$DATE/$MCYCLE/500mb_HGT/5820/ &

./cbp/build/main ./data/fields/$DATE/2m_RH/ 212 $MCYCLE 10 ./data/cbp/$DATE/$MCYCLE/2m_RH/10/ &
./cbp/build/main ./data/fields/$DATE/2m_RH/ 212 $MCYCLE 20 ./data/cbp/$DATE/$MCYCLE/2m_RH/20/ &
./cbp/build/main ./data/fields/$DATE/2m_RH/ 212 $MCYCLE 30 ./data/cbp/$DATE/$MCYCLE/2m_RH/30/ &

./cbp/build/main ./data/fields/$DATE/2m_TMP/ 212 $MCYCLE 273.15 	./data/cbp/$DATE/$MCYCLE/2m_TMP/32F/ &
./cbp/build/main ./data/fields/$DATE/2m_TMP/ 212 $MCYCLE 288.705556 ./data/cbp/$DATE/$MCYCLE/2m_TMP/60F/ &

./cbp/build/main ./data/fields/$DATE/10m_Wind/WSPD/kts/ 212 $MCYCLE 18 ./data/cbp/$DATE/$MCYCLE/10m_WSPD/18kts/ &

./cbp/build/main ./data/fields/$DATE/Haines/High/ 212 $MCYCLE 4.5 ./data/cbp/$DATE/$MCYCLE/Haines/High/5/ &

./cbp/build/main ./data/fields/$DATE/surface_APCP/3hr/  212 $MCYCLE 0.254 ./data/cbp/$DATE/$MCYCLE/surface_APCP/3hr/0_254/  &
./cbp/build/main ./data/fields/$DATE/surface_APCP/3hr/  212 $MCYCLE 2.54  ./data/cbp/$DATE/$MCYCLE/surface_APCP/3hr/2_54/  &



wait
# mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_TMP/258_15/
# mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_TMP/253_15/
# mkdir -p ./data/cbp/$DATE/$MCYCLE/500mb_TMP/248_15/
# mkdir -p ./data/cbp/$DATE/$MCYCLE/700mb_TMP/283_15/
# mkdir -p ./data/cbp/$DATE/$MCYCLE/700mb_TMP/288_15/

# ./cbp/build/main ./data/fields/$DATE/500mb_TMP/ 212 $MCYCLE 258.15 ./data/cbp/$DATE/$MCYCLE/500mb_TMP/258_15/
# ./cbp/build/main ./data/fields/$DATE/500mb_TMP/ 212 $MCYCLE 253.15 ./data/cbp/$DATE/$MCYCLE/500mb_TMP/253_15/
# ./cbp/build/main ./data/fields/$DATE/500mb_TMP/ 212 $MCYCLE 248.15 ./data/cbp/$DATE/$MCYCLE/500mb_TMP/248_15/
# ./cbp/build/main ./data/fields/$DATE/700mb_TMP/ 212 $MCYCLE 283.15 ./data/cbp/$DATE/$MCYCLE/700mb_TMP/283_15/
# ./cbp/build/main ./data/fields/$DATE/700mb_TMP/ 212 $MCYCLE 288.15 ./data/cbp/$DATE/$MCYCLE/700mb_TMP/288_15/
