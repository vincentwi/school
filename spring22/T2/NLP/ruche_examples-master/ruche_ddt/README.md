# Sample ddt job

Read "Arm-Form" in the Debugging and Profiling section of ruche documentation [https://mesocentre.pages.centralesupelec.fr/user_doc](https://mesocentre.pages.centralesupelec.fr/user_doc) 

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

Run the Forge client on your laptop. 

Bug
```shell
srun: error: node: task 0: Floating point exception
```
```
mmult(size, myrank, a, b, c);
```
should be replaced by:
```
mmult(size, nproc, a, b, c);
```
