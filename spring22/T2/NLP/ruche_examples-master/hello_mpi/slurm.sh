#!/bin/bash

#SBATCH --job-name=hello_mpi
#SBATCH --output=%x.o%j 
#SBATCH --time=00:20:00 
#SBATCH --nodes=2
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=20
#SBATCH --partition=cpu_short


# Load necessary modules
module purge
module load intel/19.0.3/gcc-4.8.5
module load intel-mpi/2019.3.199/intel-19.0.3.199

# Run MPI script
srun ./hello_mpi
