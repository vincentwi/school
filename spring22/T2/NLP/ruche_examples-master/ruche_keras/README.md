# Sample keras job

Configure keras environment (= install required anaconda packages). The configuration has to be performed on a gpu node to link the nvidia driver. The required packages are listed in config/environment.yml.

```shell
sbatch slurm_configure.sh
```

To train the sample network

```shell
sbatch slurm_train.sh
```
