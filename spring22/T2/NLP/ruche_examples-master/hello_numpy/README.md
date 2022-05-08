# Sample python job

Configure the python environment.

```shell
module load anaconda3/2020.02/gcc-9.2.0
conda create -n numpy-env
source activate numpy-env
conda install numpy
```

Submit the job to the scheduler.

```shell
sbatch slurm.sh
```
