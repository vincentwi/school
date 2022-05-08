#!/bin/bash

#SBATCH --job-name=hello_mpi4py
#SBATCH --output=%x.o%j 
#SBATCH --time=00:20:00 
#SBATCH --nodes=2 
#SBATCH --ntasks=40 
#SBATCH --ntasks-per-node=20 
#SBATCH --partition=cpu_short

# Load necessary modules
module purge
module load anaconda3/2020.02/gcc-9.2.0

# Activate anaconda environment
source activate mpi4py-env

# Run python script
mpirun -np $SLURM_NTASKS python hello_mpi4py.py
