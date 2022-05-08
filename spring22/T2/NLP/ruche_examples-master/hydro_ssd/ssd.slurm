#!/bin/bash
#SBATCH --job-name=hydrossd
#SBATCH --ntasks=1
#SBATCH --time=00:30:00
#SBATCH --output=hydrossd.%j.out
#SBATCH --error=hydrossd.%j.out
#SBATCH --mem=5gb
# Select a mem or gpu partition (SSD disks are only available on these nodes)
#SBATCH --partition=mem_short
# Reserve the required amount of SSD disk space
#SBATCH --tmp=3gb

module load intel-parallel-studio/cluster.2020.2/intel-20.0.2

# copy the binary and the input file in $TMPDIR on the local SSD disk
cp hydro $TMPDIR
cp input_sedov_noio_10000x10000.nml $TMPDIR
# run the code in $TMPDIR
cd $TMPDIR
./hydro input_sedov_noio_10000x10000.nml
# move the output files in your submission directory 
mv output* $SLURM_SUBMIT_DIR


