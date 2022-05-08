#!/bin/bash

#SBATCH --job-name=hello_julia
#SBATCH --output=%x.o%j 
#SBATCH --time=00:20:00 
#SBATCH --ntasks=1 
#SBATCH --partition=gpu

# Load the same modules as environment configuration
module load julia/1.4.0/gcc-9.2.0

# Run code
julia hello_julia.jl
