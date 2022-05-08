# Cifar10/Pytorch on **ruche**

## Cifar source code

Pytorch code for cifar10 from the Pytorch sample : [https://pytorch.org/tutorials/beginner/blitz/cifar10_tutorial.html]

## Setting Conda environment

Launch an interactive session on a GPU server.

```shell
srun --nodes=1 --time=01:00:00 --gres=gpu:1 -p gpu --pty /bin/bash
```

OR

```shell
./interactive_gpu.sh
```

In this session :

```shell
module load anaconda3/2020.02/gcc-9.2.0
module load cuda/10.2.89/intel-19.0.3.199
conda create --name pytorch
source activate pytorch
conda install pytorch torchvision matplotlib -c pytorch
conda env export > config/environment_pytorch.yml # save conda environment description
```

OR

```shell
./config/config_env.sh
```


## Cifar Data

Cifar data is automatically downloaded in current directory (342MB).


## Script detail

Scripts :
* `show_images.py` : display 4 images. Use this script for data exploration
* `train_network.py` : train the network and save state into `output/network.save`
* `train_network_gpu.py` : train the network with GPU acceleration
* `test_network.py` : test the `output/network.save` network predictions on 4 images from the validation dataset. Display the images, the tags and the predicted values.


## Launch configuration and run the sample network

### Configure environment

```shell
# configure environment
sbatch slurm_configure.sh
```

### Train the network

Train the network on CPU.

```shell
# once configuration is over, run code
sbatch slurm_train.sh
```

Train the network on GPU.

```shell
# once configuration is over, run code
sbatch slurm_train_gpu.sh
```

Output network is saved on the `output/network.save`

