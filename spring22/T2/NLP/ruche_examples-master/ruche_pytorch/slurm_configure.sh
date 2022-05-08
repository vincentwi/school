#!/bin/bash
#SBATCH --job-name=pytorch_init
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
module load cuda/10.2.89/intel-19.0.3.199

# Create conda environment
conda env create -f config/environment_pytorch.yml --force

# Save environment description
#source activate pytorch
#conda env export > config/environment_pytorch.yml
