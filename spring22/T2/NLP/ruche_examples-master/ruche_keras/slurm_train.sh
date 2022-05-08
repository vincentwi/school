#!/bin/bash

#SBATCH --job-name=ruche_keras_train
#SBATCH --output=%x.o%j 
#SBATCH --time=01:00:00 
#SBATCH --ntasks=40
#SBATCH --gres=gpu:1 
#SBATCH --partition=gpu

[ ! -d output ] && mkdir output

# Module load 
module load anaconda3/2020.02/gcc-9.2.0

# Activate anaconda environment code
source activate keras

# Train the network
python keras_cifar.py
