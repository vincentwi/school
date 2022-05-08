#!/bin/bash

#SBATCH --job-name=job-matlab
#SBATCH --output=%x.o%j 
#SBATCH --time=00:20:00 
#SBATCH --nodes=1 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --partition=cpu_short

# Module load
module purge
module load matlab/R2020a/intel-19.0.3.199

matlab -nodisplay -r hello_matlab
