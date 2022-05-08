# Intel Advisor for hydro code

See [Idris "Formation SIMD"](http://www.idris.fr/formations/simd/), "Support de cours" and "Travaux pratiques du cours" (tp3). This example uses the hydro code and the makefile of tp3.  

Read "Intel Advisor" in the Debugging and Profiling section of ruche documentation [https://mesocentre.pages.centralesupelec.fr/user_doc](https://mesocentre.pages.centralesupelec.fr/user_doc) 

Compile the example with -g.

```shell
module load intel-parallel-studio/cluster.2020.2/intel-20.0.2 
make
```

Submit the job to the scheduler to collect data

```shell
sbatch adv.slurm  
```

When the job is finished, use [ruche visualization interface](https://mesocentre.pages.centralesupelec.fr/user_doc/ruche/10_visualisation_interface/) to launch `advixe-gui` 
