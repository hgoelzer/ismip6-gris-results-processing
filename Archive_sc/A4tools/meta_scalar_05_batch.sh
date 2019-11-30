#!/bin/bash
# run a few copies of the same program in parallel
# each program puts its outputfiles in a separate directory

#!/bin/bash
# Calculate scalar values for a number of models/experiments

#set -x
set -e

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

# Destination for scalar files
outpsc=/home/hgoelzer/Projects/ISMIP6/Archive_sc/Data

## Settings
# Remove GIC contribution? 
#flg_GICmask=false # [Default true!]
flg_GICmask=true # [Default true!]
# Remove ice outside observed ice mask (can be combined with GIC masking) 
flg_OBSmask=false # [Default false!]

ares=05

#declare -a labs=(AWI AWI AWI)
#declare -a models=(ISSM1 ISSM2 ISSM3)

## labs/models lists
#declare -a labs=(ILTS_PIK)
#declare -a models=(SICOPOLIS2)

# labs/models lists
#declare -a labs=(IMAU)
#declare -a models=(NOISM05)

# labs/models lists
#declare -a labs=(JPL)
#declare -a models=(ISSM)

# labs/models lists
#declare -a labs=(MUN)
#declare -a models=(GSM2371)

# labs/models lists
#declare -a labs=(UCIJPL)
#declare -a models=(ISSM)

# labs/models lists
#declare -a labs=(VUB)
#declare -a models=(GISMSIAv1)

## labs/models lists
#declare -a labs=(LSCE)
#declare -a models=(GRISLI)




# labs/models lists
#declare -a labs=(LSCE)
#declare -a models=(GRISLI)

# labs/models lists
#declare -a labs=(IMAU LSCE)
#declare -a models=(IMAUICE2 GRISLI)

# labs/models lists
#declare -a labs=(ILTS_PIK IMAU LSCE)
#declare -a models=(SICOPOLIS2 IMAUICE2 GRISLI)

# labs/models lists
#declare -a labs=(AWI AWI AWI ILTS_PIK ILTS_PIK IMAU JPL JPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 SICOPOLIS2 SICOPOLIS3 IMAUICE1 ISSM ISSMPALEO)

# labs/models lists
#declare -a labs=(GSFC  ILTS_PIK ILTS_PIK  JPL JPL  LSCE  MUN MUN  UCIJPL)
#declare -a models=(ISSM SICOPOLIS2 SICOPOLIS3 ISSM ISSMPALEO GRISLI GSM2501 GSM2511 ISSM)

# labs/models lists
#declare -a labs=(GSFC ILTS_PIK ILTS_PIK IMAU JPL JPL LSCE UAF UCIJPL)
#declare -a models=(ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE2 ISSM ISSMPALEO GRISLI PISM1 ISSM1)

#declare -a labs=(BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)

# labs/models lists
#declare -a labs=(BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)

#declare -a labs=(BGC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(BISICLES SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)

#declare -a labs=(AWI AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)

# or source default labs list
source ./set_default.sh


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

    # A. set exps manually
    #exps_res=asmb_05
    #exps_res="ctrl_05 historical_05"
    #exps_res="exp05_05"
    #exps_res="historical_05"
    #exps_res="ctrl_05"
    #exps_res="ctrl_proj_05 historical_05 exp05_05"
    #exps_res="historical_05 ctrl_proj_05 exp05_05"
    #exps_res="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05 "
    
    #exps_res="historical_05 ctrl_proj_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05 "
    #exps_res="ctrl_proj_05 exp05_05"

    exps_res="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05 expa01_05 expa02_05 expa03_05"

    
    # B. find experiments automatically
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*`
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_05`
    #exps_res=`basename -a ${dexps}`

    # loop trough experiments to calculate scalars
    for exp_res in ${exps_res}; do

	proc=${labs[$counter]}_${models[$counter]}_${exp_res}
	mkdir -p ${proc}

	(

#	    ./scalar_05_batch_func.sh ${outp} ${labs[$counter]} ${models[$counter]} ${exp_res} ${flg_GICmask} ${flg_OBSmask} ${ares} ${outpsc} &> ${labs[$counter]}_${models[$counter]}_${exp_res}/job.out

	    ./scalar_05_batch_func.sh ${outp} ${labs[$counter]} ${models[$counter]} ${exp_res} ${flg_GICmask} ${flg_OBSmask} ${ares} ${outpsc} &> ${outpsc}/${labs[$counter]}_${models[$counter]}_${exp_res}.out

	)&

    done
    # end exp loop

    counter=$(( counter+1 )) 
done
# end lab/model loop


# wait until all background processes are ended:
wait 
