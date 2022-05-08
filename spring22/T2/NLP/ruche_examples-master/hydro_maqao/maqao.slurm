#!/bin/bash
#SBATCH --job-name=hydromaqao
#SBATCH --ntasks=1
#SBATCH --time=00:30:00
#SBATCH --output=hydromaqao.%j.out
#SBATCH --error=hydromaqao.%j.out
#SBATCH --partition=cpu_short

module load intel-parallel-studio/cluster.2020.2/intel-20.0.2

module load maqao/2.14.1/gcc-9.2.0

# ./hydro input_sedov_noio_10000x10000.nml
maqao lprof -- ./hydro input_sedov_noio_10000x10000.nml


