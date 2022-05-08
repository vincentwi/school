#!/bin/bash

#SBATCH --job-name=hello_numpy
#SBATCH --output=%x.o%j 
#SBATCH --time=00:20:00 
#SBATCH --ntasks=1 
#SBATCH --partition=cpu_short

# Load necessary modules
module purge
module load anaconda3/2020.02/gcc-9.2.0

# Activate anaconda environment
source activate numpy-env

# Run python script
python hello_numpy.py
