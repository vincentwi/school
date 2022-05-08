#!/bin/bash

#SBATCH --job-name=hello_array
#SBATCH --output=%x.o%A_%a
#SBATCH --time=00:20:00 
#SBATCH --ntasks=1
#SBATCH --partition=cpu_short
#SBATCH --array=1-10

# This script will be executed on remote server
# like a standard bash script
echo "Hello from array n°$SLURM_ARRAY_TASK_ID of $SLURM_ARRAY_TASK_COUNT"
hostname
date
sleep 20
