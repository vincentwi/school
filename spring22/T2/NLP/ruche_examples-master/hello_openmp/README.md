# Sample OpenMP job

Compile this example.

```shell
module load intel/19.0.3/gcc-4.8.5
icc -qopenmp hello_omp.c
```

Submit the job to the scheduler.

```shell
sbatch slurm.sh
```
