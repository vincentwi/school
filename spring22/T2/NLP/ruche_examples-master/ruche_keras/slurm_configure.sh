#!/bin/bash

#SBATCH --job-name=ruche_keras_init
#SBATCH --output=%x.o%j 
#SBATCH --time=01:00:00 
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1 
#SBATCH --partition=gpu

# Setup conda env - ensure your .conda dir is located on your workir, and move it if not
[ -L ~/.conda ] && unlink ~/.conda
[ -d ~/.conda ] && mv -v ~/.conda $WORKDIR
[ ! -d $WORKDIR/.conda ] && mkdir $WORKDIR/.conda
ln -s $WORKDIR/.conda ~/.conda

# Module load
module load anaconda3/2020.02/gcc-9.2.0

# Create conda environment
conda env create -f config/environment_keras.yml --force

# Save environment description
#source activate keras
#conda env export > config/environment_keras.yml
