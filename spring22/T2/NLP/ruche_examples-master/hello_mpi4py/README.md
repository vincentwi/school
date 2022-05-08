# Sample python job

Configure the python environment.

```shell
module load anaconda3/2020.02/gcc-9.2.0
conda create -n mpi4py-env
source activate mpi4py-env
conda install mpi4py
```

Submit the job to the scheduler.

```shell
sbatch slurm.sh
```
