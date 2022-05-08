#!/bin/bash

#SBATCH --job-name=hello_seq
#SBATCH --output=%x.o%j 
#SBATCH --time=00:20:00 
#SBATCH --ntasks=1 
#SBATCH --partition=cpu_short

# Load necessary modules
module purge
module load intel/19.0.3/gcc-4.8.5

# Run executable
./a.out
