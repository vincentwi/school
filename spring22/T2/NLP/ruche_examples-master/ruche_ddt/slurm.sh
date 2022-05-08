#!/bin/bash

#! SBATCH Directives
#SBATCH --job-name=cpujob
#SBATCH --output=%x.o%j
#SBATCH --time=01:00:00
#SBATCH --ntasks=4
# number of licenses should be equal to ntask
#SBATCH --licenses=arm-forge:4
#SBATCH --partition=cpu_short

# To clean and to load the same modules at the compilation phases
module purge
module load intel/19.0.3/gcc-4.8.5
module load arm-forge/20.1.3-Redhat-7.0/intel-19.0.3.199
module load intel-mpi/2019.3.199/intel-19.0.3.199

# To compute in the submission directory
application="$SLURM_SUBMIT_DIR/mmult"

#! Work directory (i.e. where will the job run)
workdir="$SLURM_SUBMIT_DIR"

# execution with 'ntasks' MPI processes
ddt --connect --mem-debug=balanced srun -n $SLURM_NTASKS $application 
