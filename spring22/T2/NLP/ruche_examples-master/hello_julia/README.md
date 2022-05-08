# Sample julia job

To configure julia environment (install required packages)

```shell
module load julia/1.4.0/gcc-9.2.0
julia configure_env.jl
```

To launch this example

```shell
sbatch slurm.sh
```
