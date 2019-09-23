#!/bin/bash
# process a number of files

set -x

# location of Archive
outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05
#outp=/home/hgoelzer/Projects/ISMIP6/Archive_05

# location of tools
ptool=${outp}/ismip6-gris-results-processing

#declare -a labs=(AWI)
#declare -a models=(ISSM2)

## labs/models lists
#declare -a labs=(ILTS_PIK)
#declare -a models=(SICOPOLIS2)

# labs/models lists
#declare -a labs=(MUN)
#declare -a models=(GSM2371)

# labs/models lists
#declare -a labs=(UCIJPL)
#declare -a models=(ISSM)

# labs/models lists
#declare -a labs=(VUB)
#declare -a models=(GISMSIAv1)

# labs/models lists
declare -a labs=(LSCE)
declare -a models=(GRISLI)

# labs/models lists
#declare -a labs=(AWI AWI AWI ILTS_PIK ILTS_PIK IMAU JPL JPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 SICOPOLIS2 SICOPOLIS3 IMAUICE1 ISSM ISSMPALEO)

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

##### 
echo "------------------"
echo  netcdf calculations
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]} ${models[$counter]}
    # set exps manually
    #exps_res=asmb_05
    #exps_res="ctrl_05 hist_05"
    exps_res="exp05_05"
    #exps_res="hist_05"
    
    # find experiments
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*`
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_05`
    #exps_res=`basename -a ${dexps}`

    echo "###"
    echo ${exps_res}

    
    # loop trough experiments to calculate scalars
    for exp_res in ${exps_res}; do

	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}
	# input file name
	anc=${apath}/lithk_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -O -v lithk ${anc} model.nc
	anc=${apath}/topg_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -A -v topg ${anc} model.nc

	anc=${apath}/sftflf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -A -v sftflf ${anc} model.nc
	anc=${apath}/sftgif_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -A -v sftgif ${anc} model.nc
	anc=${apath}/sftgrf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -A -v sftgrf ${anc} model.nc

	### scalar calculations; expect model input in model.nc
	#./scalars_opt.sh
	./scalars_basin.sh

	### move output ./scalars_??_05.nc to Archive
	/bin/mv ./scalars_mm_05.nc ${apath}/scalars_mm_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	/bin/mv ./scalars_bm_05.nc ${apath}/scalars_bm_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	/bin/mv ./scalars_ng_05.nc ${apath}/scalars_ng_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	/bin/mv ./scalars_mm_imb_05.nc ${apath}/scalars_mm_imb_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	#/bin/rm model.nc
    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop
