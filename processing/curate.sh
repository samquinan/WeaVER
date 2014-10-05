#!/bin/bash
if [[ $# != 2 ]]; then
	echo "Usage: curate.sh DATE MCYCLE"
	exit 1
fi

DATE="$1"
MCYCLE=`printf "%02d" ${2#0}`

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

find ./data/fields/$DATE/850mb_HGT/derived -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/850mb_HGT/
find ./data/fields/$DATE/850mb_RH/derived  -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/850mb_RH/
find ./data/fields/$DATE/850mb_TMP/derived -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/850mb_TMP/
find ./data/fields/$DATE/700mb_HGT/derived -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/700mb_HGT/
find ./data/fields/$DATE/700mb_RH/derived  -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/700mb_RH/
find ./data/fields/$DATE/700mb_TMP/derived 					  			-name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/700mb_TMP/
find ./data/fields/$DATE/500mb_HGT/derived -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/500mb_HGT/
find ./data/fields/$DATE/500mb_RH/derived  -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/500mb_RH/
find ./data/fields/$DATE/500mb_TMP/derived 				 				-name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/500mb_TMP/
find ./data/fields/$DATE/300mb_HGT/derived -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/300mb_HGT/
find ./data/fields/$DATE/300mb_RH/derived  -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/300mb_RH/
find ./data/fields/$DATE/300mb_TMP/derived -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/300mb_TMP/
find ./data/fields/$DATE/200mb_HGT/derived -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/200mb_HGT/
find ./data/fields/$DATE/200mb_RH/derived  -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/200mb_RH/
find ./data/fields/$DATE/200mb_TMP/derived -name *.stddev.txt -prune -o -name '*.t'$MCYCLE'z*' -type f -print  | xargs -I{} cp {} ./curated/StatFields/200mb_TMP/

mkdir -p ./curated/StatFields/850mb_Wind/
mkdir -p ./curated/StatFields/700mb_Wind/
mkdir -p ./curated/StatFields/500mb_Wind/
mkdir -p ./curated/StatFields/300mb_Wind/
mkdir -p ./curated/StatFields/200mb_Wind/

find ./data/fields/$DATE/850mb_Wind/derived -name '*.t'$MCYCLE'z*' -type f | xargs -I{} cp {} ./curated/StatFields/850mb_Wind/
find ./data/fields/$DATE/700mb_Wind/derived -name '*.t'$MCYCLE'z*' -type f | xargs -I{} cp {} ./curated/StatFields/700mb_Wind/
find ./data/fields/$DATE/500mb_Wind/derived -name '*.t'$MCYCLE'z*' -type f | xargs -I{} cp {} ./curated/StatFields/500mb_Wind/
find ./data/fields/$DATE/300mb_Wind/derived -name '*.t'$MCYCLE'z*' -type f | xargs -I{} cp {} ./curated/StatFields/300mb_Wind/
find ./data/fields/$DATE/200mb_Wind/derived -name '*.t'$MCYCLE'z*' -type f | xargs -I{} cp {} ./curated/StatFields/200mb_Wind/

# Ensemble Fields
mkdir -p ./curated/EnsembleFields/500mb_HGT/

find ./data/fields/$DATE/500mb_HGT -maxdepth 1 -mindepth 1 -name '*.t'$MCYCLE'z*' -type f | xargs -I{} cp {} ./curated/EnsembleFields/500mb_HGT/

# Deterministic as em ctl member
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

find ./data/fields/$DATE/850mb_HGT -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/850mb_HGT/
find ./data/fields/$DATE/850mb_RH  -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/850mb_RH/
find ./data/fields/$DATE/850mb_TMP -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/850mb_TMP/
find ./data/fields/$DATE/700mb_HGT -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/700mb_HGT/
find ./data/fields/$DATE/700mb_RH  -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/700mb_RH/
find ./data/fields/$DATE/700mb_TMP -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/700mb_TMP/
find ./data/fields/$DATE/500mb_HGT -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/500mb_HGT/
find ./data/fields/$DATE/500mb_RH  -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/500mb_RH/
find ./data/fields/$DATE/500mb_TMP -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/500mb_TMP/
find ./data/fields/$DATE/300mb_HGT -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/300mb_HGT/
find ./data/fields/$DATE/300mb_RH  -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/300mb_RH/
find ./data/fields/$DATE/300mb_TMP -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/300mb_TMP/
find ./data/fields/$DATE/200mb_HGT -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/200mb_HGT/
find ./data/fields/$DATE/200mb_RH  -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/200mb_RH/
find ./data/fields/$DATE/200mb_TMP -maxdepth 1 -mindepth 1 -name '*em.t'$MCYCLE'z.*.ctl.*.txt' -type f | xargs -I{} cp {} ./curated/EnsembleFields/200mb_TMP/

# Contour Box Plots
mkdir -p ./curated/CBP/500mb_HGT/

find ./data/cbp/$DATE/$MCYCLE/500mb_HGT -maxdepth 1 -mindepth 1 -type d | xargs -I{} cp -r {} ./curated/CBP/500mb_HGT/

# Probability
mkdir -p ./curated/Probabilities/2m_RH/
mkdir -p ./curated/Probabilities/10m_WSPD/
mkdir -p ./curated/Probabilities/12hr_APCP/

find ./data/fields/$DATE/2m_RH/prob 			-name '*.t'$MCYCLE'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/2m_RH/
find ./data/fields/$DATE/10m_Wind/prob 		 	-name '*.t'$MCYCLE'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/10m_WSPD/
find ./data/fields/$DATE/surface_APCP/12hr/prob -name '*.t'$MCYCLE'z*' -type f | xargs -I{} cp {} ./curated/Probabilities/12hr_APCP/


# move
mv ./curated ../datasets



