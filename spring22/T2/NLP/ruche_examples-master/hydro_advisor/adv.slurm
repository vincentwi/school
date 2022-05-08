#!/bin/bash
#SBATCH --job-name=hydroadvice
#SBATCH --ntasks=1
#SBATCH --time=00:30:00
#SBATCH --output=hydroadvice.%j.out
#SBATCH --error=hydroadvice.%j.out
#SBATCH --partition=cpu_short

module load intel-parallel-studio/cluster.2020.2/intel-20.0.2 

advixe-cl -collect survey -interval=10 -data-limit=1024000 -project-dir ./Adv/ -- ./hydro input_sedov_noio_10000x10000.nml
advixe-cl -collect tripcounts -flop -interval=10 -data-limit=1024000 -project-dir ./Adv/ -- ./hydro input_sedov_noio_10000x10000.nml
