#!/bin/bash

#SBATCH --job-name=hello_mpi_openmp
#SBATCH --output=%x.o%j 
#SBATCH --time=00:20:00 
#SBATCH --nodes=2
#SBATCH --ntasks=4 
#SBATCH --ntasks-per-node=2
#SBATCH --threads-per-core=1
#SBATCH --cpus-per-task=10
#SBATCH --partition=cpu_short

# Load necessary modules
module purge
module load intel/19.0.3/gcc-4.8.5
module load intel-mpi/2019.3.199/intel-19.0.3.199

# Set OpenMP threads
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}

# Binding OpenMP Threads of each MPI process on cores
export OMP_PLACES=cores

# Run the OpenMP-MPI executable
srun ./hello_mpi_openmp
