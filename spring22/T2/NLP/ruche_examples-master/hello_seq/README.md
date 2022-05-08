# Sample sequential job

Compile the C code.

```shell
module load intel/19.0.3/gcc-4.8.5
icc hello_seq.c
```

Submit the code to the scheduler.

```shell 
sbatch slurm.sh
```
