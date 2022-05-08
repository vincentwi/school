module load anaconda3/2021.05/gcc-9.2.0
module load cuda/11.4.0/intel-20.0.2
conda create --name keras
source activate keras
conda install tensorflow-gpu
conda install keras
conda env export > config/environment_keras.yml # save conda environment description
