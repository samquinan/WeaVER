#!/bin/bash
if [[ $# != 2 ]]; then
	echo "Usage: curate.sh DATE RUN"
	exit 1
fi

# This script copies the files expected by WeaVER into a seperate directory.

DATE="$1"
RUN=`printf "%02d" ${2#0}`

# Stat Fields
echo copying stat fields...

# HGT, RH, TMP, DPT
# generate expected file structure
mkdir -p ./curated/StatFields/850mb_HGT/
mkdir -p ./curated/StatFields/850mb_RH/
mkdir -p ./curated/StatFields/850mb_TMP/
mkdir -p ./curated/StatFields/700mb_HGT/
mkdir -p ./curated/StatFields/700mb_RH/
mkdir -p ./curated/StatFields/700mb_TMP/
mkdir -p ./curated/StatFields/500mb_HGT/
mkdir -p ./curated/StatFields/500mb_RH/
mkdir -p ./curated/StatFields/500mb_TMP/
mkdir -p ./curated/StatFields/300mb_HGT/
mkdir -p ./curated/StatFields/300mb_RH/
mkdir -p ./curated/StatFields/300mb_TMP/
mkdir -p ./curated/StatFields/200mb_HGT/
mkdir -p ./curated/StatFields/200mb_RH/
mkdir -p ./curated/StatFields/200mb_TMP/
mkdir -p ./curated/StatFields/2m_TMP/
mkdir -p ./curated/StatFields/2m_RH/
mkdir -p ./curated/StatFields/2m_DPT/

# copy requisite files
find ./data/fields/$DATE/850mb_HGT/derived -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/850mb_HGT/
find ./data/fields/$DATE/850mb_RH/derived  -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/850mb_RH/
find ./data/fields/$DATE/850mb_TMP/derived -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/850mb_TMP/
find ./data/fields/$DATE/700mb_HGT/derived -type f  							-name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/700mb_HGT/
find ./data/fields/$DATE/700mb_RH/derived  -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/700mb_RH/
find ./data/fields/$DATE/700mb_TMP/derived -type f 					  			-name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/700mb_TMP/
find ./data/fields/$DATE/500mb_HGT/derived -type f  							-name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/500mb_HGT/
find ./data/fields/$DATE/500mb_RH/derived  -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/500mb_RH/
find ./data/fields/$DATE/500mb_TMP/derived -type f 				 				-name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/500mb_TMP/
find ./data/fields/$DATE/300mb_HGT/derived -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/300mb_HGT/
find ./data/fields/$DATE/300mb_RH/derived  -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/300mb_RH/
find ./data/fields/$DATE/300mb_TMP/derived -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/300mb_TMP/
find ./data/fields/$DATE/200mb_HGT/derived -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/200mb_HGT/
find ./data/fields/$DATE/200mb_RH/derived  -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/200mb_RH/
find ./data/fields/$DATE/200mb_TMP/derived -type f -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -print  | xargs -I{} cp {} ./curated/StatFields/200mb_TMP/

find ./data/fields/$DATE/2m_TMP/derived -type f -name *.max.txt -prune -o -name *.min.txt -prune -o -name '*.t'$RUN'z*' -print | xargs -I{} cp {} ./curated/StatFields/2m_TMP/
find ./data/fields/$DATE/2m_RH/derived  -type f -name *.max.txt -prune -o -name *.min.txt -prune -o -name '*.t'$RUN'z*' -print | xargs -I{} cp {} ./curated/StatFields/2m_RH/
find ./data/fields/$DATE/2m_DPT/derived -type f -name *.max.txt -prune -o -name *.min.txt -prune -o -name '*.t'$RUN'z*' -print | xargs -I{} cp {} ./curated/StatFields/2m_DPT/

# WIND
# generate expected file structure
mkdir -p ./curated/StatFields/850mb_Wind/
mkdir -p ./curated/StatFields/700mb_Wind/
mkdir -p ./curated/StatFields/500mb_Wind/
mkdir -p ./curated/StatFields/300mb_Wind/
mkdir -p ./curated/StatFields/200mb_Wind/
mkdir -p ./curated/StatFields/10m_Wind/

# copy requisite files
find ./data/fields/$DATE/850mb_Wind/derived -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/StatFields/850mb_Wind/
find ./data/fields/$DATE/700mb_Wind/derived -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/StatFields/700mb_Wind/
find ./data/fields/$DATE/500mb_Wind/derived -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/StatFields/500mb_Wind/
find ./data/fields/$DATE/300mb_Wind/derived -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/StatFields/300mb_Wind/
find ./data/fields/$DATE/200mb_Wind/derived -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/StatFields/200mb_Wind/
find ./data/fields/$DATE/10m_Wind/derived/kts -maxdepth 1 -mindepth 1 -type f -name *.min.txt -prune -o -name '*.t'$RUN'z*' -print | xargs -I{} cp {} ./curated/StatFields/10m_Wind/

# HAINES INDEX
# generating expected file structure
mkdir -p ./curated/StatFields/Haines/Low/
mkdir -p ./curated/StatFields/Haines/Med/
mkdir -p ./curated/StatFields/Haines/High/

# copy requisite files
find ./data/fields/$DATE/Haines/Low/derived  -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/Haines/Low/
find ./data/fields/$DATE/Haines/Med/derived  -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/Haines/Med/
find ./data/fields/$DATE/Haines/High/derived -name *.stddev.txt -prune -o -name '*.t'$RUN'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/Haines/High/

# APCP
# generating expected file structure
mkdir -p ./curated/StatFields/surface_APCP/3hr/
mkdir -p ./curated/StatFields/surface_APCP/6hr/
mkdir -p ./curated/StatFields/surface_APCP/12hr/
mkdir -p ./curated/StatFields/surface_APCP/24hr/

# copy requisite files
find ./data/fields/$DATE/surface_APCP/3hr/derived  -type f -name *.max.txt -name '*.t'$RUN'z*' -print | xargs -I{} cp {} ./curated/StatFields/surface_APCP/3hr/
find ./data/fields/$DATE/surface_APCP/6hr/derived  -type f -name *.max.txt -name '*.t'$RUN'z*' -print | xargs -I{} cp {} ./curated/StatFields/surface_APCP/6hr/
find ./data/fields/$DATE/surface_APCP/12hr/derived -type f -name *.max.txt -name '*.t'$RUN'z*' -print | xargs -I{} cp {} ./curated/StatFields/surface_APCP/12hr/
find ./data/fields/$DATE/surface_APCP/24hr/derived -type f -name *.max.txt -name '*.t'$RUN'z*' -print | xargs -I{} cp {} ./curated/StatFields/surface_APCP/24hr/

# Ensemble Fields
echo copying ensemble fields...

# generating expected file structure
mkdir -p ./curated/EnsembleFields/500mb_HGT/
mkdir -p ./curated/EnsembleFields/10m_Wind/
mkdir -p ./curated/EnsembleFields/2m_TMP/
mkdir -p ./curated/EnsembleFields/2m_RH/
mkdir -p ./curated/EnsembleFields/surface_APCP/3hr/
mkdir -p ./curated/EnsembleFields/Haines/High/

# copy requisite files
find ./data/fields/$DATE/500mb_HGT -maxdepth 1 -mindepth 1 -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/EnsembleFields/500mb_HGT/
find ./data/fields/$DATE/10m_Wind/WSPD/kts/ -maxdepth 1 -mindepth 1 -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/EnsembleFields/10m_Wind/
find ./data/fields/$DATE/2m_TMP -maxdepth 1 -mindepth 1 -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/EnsembleFields/2m_TMP/
find ./data/fields/$DATE/2m_RH  -maxdepth 1 -mindepth 1 -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/EnsembleFields/2m_RH/
find ./data/fields/$DATE/surface_APCP/3hr  -maxdepth 1 -mindepth 1 -name '*t'$RUN'z*' -type f -print | xargs -I{} cp {} ./curated/EnsembleFields/surface_APCP/3hr/
find ./data/fields/$DATE/Haines/High/ -maxdepth 1 -mindepth 1 -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/EnsembleFields/Haines/High/

# Deterministic -- treating arw/em ctl member, as a deterinsitic run
echo copying deterministic fields...

# convenience variables
MODEL=arw
PTRB=ctl

# HGT, RH, TMP, DPT
# generating expected file structure
mkdir -p ./curated/EnsembleFields/850mb_HGT/
mkdir -p ./curated/EnsembleFields/850mb_RH/
mkdir -p ./curated/EnsembleFields/850mb_TMP/
mkdir -p ./curated/EnsembleFields/700mb_HGT/
mkdir -p ./curated/EnsembleFields/700mb_RH/
mkdir -p ./curated/EnsembleFields/700mb_TMP/
mkdir -p ./curated/EnsembleFields/500mb_HGT/
mkdir -p ./curated/EnsembleFields/500mb_RH/
mkdir -p ./curated/EnsembleFields/500mb_TMP/
mkdir -p ./curated/EnsembleFields/300mb_HGT/
mkdir -p ./curated/EnsembleFields/300mb_RH/
mkdir -p ./curated/EnsembleFields/300mb_TMP/
mkdir -p ./curated/EnsembleFields/200mb_HGT/
mkdir -p ./curated/EnsembleFields/200mb_RH/
mkdir -p ./curated/EnsembleFields/200mb_TMP/
mkdir -p ./curated/EnsembleFields/surface_APCP/6hr/
mkdir -p ./curated/EnsembleFields/surface_APCP/12hr/
mkdir -p ./curated/EnsembleFields/surface_APCP/24hr/
mkdir -p ./curated/EnsembleFields/2m_DPT/

# copy requisite files
find ./data/fields/$DATE/850mb_HGT -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/850mb_HGT/
find ./data/fields/$DATE/850mb_RH  -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/850mb_RH/
find ./data/fields/$DATE/850mb_TMP -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/850mb_TMP/
find ./data/fields/$DATE/700mb_HGT -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/700mb_HGT/
find ./data/fields/$DATE/700mb_RH  -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/700mb_RH/
find ./data/fields/$DATE/700mb_TMP -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/700mb_TMP/
find ./data/fields/$DATE/500mb_HGT -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/500mb_HGT/
find ./data/fields/$DATE/500mb_RH  -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/500mb_RH/
find ./data/fields/$DATE/500mb_TMP -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/500mb_TMP/
find ./data/fields/$DATE/300mb_HGT -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/300mb_HGT/
find ./data/fields/$DATE/300mb_RH  -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/300mb_RH/
find ./data/fields/$DATE/300mb_TMP -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/300mb_TMP/
find ./data/fields/$DATE/200mb_HGT -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/200mb_HGT/
find ./data/fields/$DATE/200mb_RH  -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/200mb_RH/
find ./data/fields/$DATE/200mb_TMP -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/200mb_TMP/
find ./data/fields/$DATE/surface_APCP/6hr  -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/surface_APCP/6hr/
find ./data/fields/$DATE/surface_APCP/12hr -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/surface_APCP/12hr/
find ./data/fields/$DATE/surface_APCP/24hr -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/surface_APCP/24hr/
find ./data/fields/$DATE/2m_DPT -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/2m_DPT/

# WIND
# generate expected file structure
mkdir -p ./curated/EnsembleFields/850mb_Wind/
mkdir -p ./curated/EnsembleFields/700mb_Wind/
mkdir -p ./curated/EnsembleFields/500mb_Wind/
mkdir -p ./curated/EnsembleFields/300mb_Wind/
mkdir -p ./curated/EnsembleFields/200mb_Wind/

# # copy requisite files
find ./data/fields/$DATE/850mb_Wind/dtrm/kts -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/850mb_Wind/
find ./data/fields/$DATE/700mb_Wind/dtrm/kts -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/700mb_Wind/
find ./data/fields/$DATE/500mb_Wind/dtrm/kts -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/500mb_Wind/
find ./data/fields/$DATE/300mb_Wind/dtrm/kts -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/300mb_Wind/
find ./data/fields/$DATE/200mb_Wind/dtrm/kts -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/200mb_Wind/
find ./data/fields/$DATE/10m_Wind/dtrm/kts -name '*'$MODEL'.t'$RUN'z*.'$PTRB'.*.WDIR.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/10m_Wind/

# HAINES INDEX
# generate expected file structure
mkdir -p ./curated/EnsembleFields/Haines/Low/
mkdir -p ./curated/EnsembleFields/Haines/Med/

# # copy requisite files
find ./data/fields/$DATE/Haines/Low/  -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/Haines/Low/
find ./data/fields/$DATE/Haines/Med/  -maxdepth 1 -mindepth 1 -name '*'$MODEL'.t'$RUN'z.*.'$PTRB'.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/Haines/Med/

# Contour Box Plots
echo copying contour boxplot analysis...

# generate expected file structure
mkdir -p ./curated/CBP/500mb_HGT/
mkdir -p ./curated/CBP/2m_RH/
mkdir -p ./curated/CBP/2m_TMP/
mkdir -p ./curated/CBP/10m_WSPD/
mkdir -p ./curated/CBP/Haines/High/
mkdir -p ./curated/CBP/surface_APCP/3hr/

# copy requisite files
find ./data/cbp/$DATE/$RUN/500mb_HGT    		-maxdepth 1 -mindepth 1 -type d | xargs -I{} cp -r {} ./curated/CBP/500mb_HGT/
find ./data/cbp/$DATE/$RUN/2m_RH        		-maxdepth 1 -mindepth 1 -type d | xargs -I{} cp -r {} ./curated/CBP/2m_RH/
find ./data/cbp/$DATE/$RUN/2m_TMP       		-maxdepth 1 -mindepth 1 -type d | xargs -I{} cp -r {} ./curated/CBP/2m_TMP/
find ./data/cbp/$DATE/$RUN/10m_WSPD     		-maxdepth 1 -mindepth 1 -type d | xargs -I{} cp -r {} ./curated/CBP/10m_WSPD/
find ./data/cbp/$DATE/$RUN/Haines/High  		-maxdepth 1 -mindepth 1 -type d | xargs -I{} cp -r {} ./curated/CBP/Haines/High/
find ./data/cbp/$DATE/$RUN/surface_APCP/3hr  -maxdepth 1 -mindepth 1 -type d | xargs -I{} cp -r {} ./curated/CBP/surface_APCP/3hr/

# Probability
echo copying probability fields...

# generate expected file structure
mkdir -p ./curated/Probabilities/2m_RH/
mkdir -p ./curated/Probabilities/2m_TMP/
mkdir -p ./curated/Probabilities/10m_WSPD/kts/
mkdir -p ./curated/Probabilities/10m_WSPD/mph/
mkdir -p ./curated/Probabilities/3hr_APCP/
mkdir -p ./curated/Probabilities/6hr_APCP/
mkdir -p ./curated/Probabilities/12hr_APCP/
mkdir -p ./curated/Probabilities/24hr_APCP/
mkdir -p ./curated/Probabilities/Haines/High/
mkdir -p ./curated/Probabilities/Haines/Med/
mkdir -p ./curated/Probabilities/Haines/Low/

# copy requisite files
find ./data/fields/$DATE/2m_RH/prob 			-name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/2m_RH/
find ./data/fields/$DATE/2m_TMP/prob 			-name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/2m_TMP/
find ./data/fields/$DATE/10m_Wind/prob/kts	 	-name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/10m_WSPD/kts/
find ./data/fields/$DATE/10m_Wind/prob/mph	 	-name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/10m_WSPD/mph/
find ./data/fields/$DATE/surface_APCP/3hr/prob  -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/3hr_APCP/
find ./data/fields/$DATE/surface_APCP/6hr/prob  -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/6hr_APCP/
find ./data/fields/$DATE/surface_APCP/12hr/prob -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/12hr_APCP/
find ./data/fields/$DATE/surface_APCP/24hr/prob -name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/24hr_APCP/
find ./data/fields/$DATE/Haines/High/prob/		-name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/Haines/High/
find ./data/fields/$DATE/Haines/Med/prob/		-name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/Haines/Med/
find ./data/fields/$DATE/Haines/Low/prob/		-name '*.t'$RUN'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/Haines/Low/

# Finalize
echo replacing previous...

# blow away previous
rm -rf ../datasets
rm -f ../dataset.properties

# move new into place
mv ./curated ../datasets
echo run=$RUN > ../dataset.properties
echo date=$DATE >> ../dataset.properties

echo completed.



