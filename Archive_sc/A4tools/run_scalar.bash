#!/bin/bash
#SBATCH -p short -n 24 -t 0:50:00

# For interactive use:
# srun -t 10 -N 1 --pty bash -il
# ./run_process.bash

# setting up
exppath=`realpath ./` 
scrpath=/scratch/shared/$USER/ISMIP6

# working on /scratch 
if [ -d "$scrpath" ]; then rm -rf $scrpath; fi
mkdir -p $scrpath
cd $scrpath

# get scripts
/bin/cp ${exppath}/meta_scalar.sh ./
/bin/cp ${exppath}/scalars_basin.sh ./

# run the model. For interactive use:
# srun -t 10 -N 1 --pty bash -il
./meta_scalar.sh

# clean up
#/bin/rm $scrpath

echo ''
echo '  FINISHED '
echo ''

echo 'The meta script was:'
echo '#####'
cat meta_scalar.sh
echo 'The run script was:'
echo '#####'
cat scalars_basin.sh
echo '#####'
