#!/bin/bash

#SBATCH --job-name=hello_bash
#SBATCH --output=%x.o%j 
#SBATCH --time=00:20:00 
#SBATCH --ntasks=1
#SBATCH --partition=cpu_short

# This script will be executed on remote server
# like a standard bash script
hostname
date
sleep 20
