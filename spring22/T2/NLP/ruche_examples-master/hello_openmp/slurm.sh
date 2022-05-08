#!/bin/bash

#SBATCH --job-name=hello_openmp
#SBATCH --output=%x.o%j 
#SBATCH --time=00:20:00 
#SBATCH --ntasks=1 
#SBATCH --partition=cpu_short
#SBATCH --threads-per-core=1
#SBATCH --cpus-per-task=4

# Load necessary modules
module purge
module load intel/19.0.3/gcc-4.8.5

# Setup OpenMP threads
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}

# Run OpenMP script
./a.out
