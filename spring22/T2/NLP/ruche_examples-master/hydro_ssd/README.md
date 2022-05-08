# Hydro code with IOs on SSD

Hydro code from [Idris "Formation SIMD"](http://www.idris.fr/formations/simd/), "Support de cours" and "Travaux pratiques du cours" (tp3). This example uses the hydro code and the makefile of tp3.  

See [this page](https://mesocentre.pages.centralesupelec.fr/user_doc/ruche/06_slurm_jobs_management/#how-to-describe-your-requested-ressources-with-sbatch) for more information on the use of SSD disks.

```shell
module load intel-parallel-studio/cluster.2020.2/intel-20.0.2 
make
```

Submit the job to the scheduler

```shell
sbatch ssd.slurm  
```

