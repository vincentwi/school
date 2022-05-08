# Sample MPI job

Compile the example.

```shell
module load intel/19.0.3/gcc-4.8.5
module load intel-mpi/2019.3.199/intel-19.0.3.199
make
```

Submit the job to the scheduler

```shell
sbatch slurm.sh
```
