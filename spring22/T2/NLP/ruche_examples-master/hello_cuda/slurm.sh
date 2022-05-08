#!/bin/bash

#SBATCH --job-name=hello_cuda
#SBATCH --output=%x.o%j 
#SBATCH --time=00:20:00 
#SBATCH --ntasks=1 
#SBATCH --gres=gpu:1
#SBATCH --partition=gpu

# Load necessary modules
module load cuda/10.2.89/intel-19.0.3.199

# Compile cuda code - comment if you don't want to recompile
nvcc hello_cuda.cu

# Run cuda code
./a.out
