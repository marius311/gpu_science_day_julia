#!/bin/bash
#SBATCH -C gpu 
#SBATCH -q regular
#SBATCH -t 00:05:00 
#SBATCH --cpus-per-task 32 
#SBATCH --gpus-per-task 1 
#SBATCH --ntasks-per-node 4
#SBATCH --nodes 4
#SBATCH -A mp107
#=

srun /global/u1/m/marius/.julia/juliaup/julia-1.9.3+0.x64.linux.gnu/bin/julia $(scontrol show job $SLURM_JOBID | awk -F= '/Command=/{print $2}')
exit 0

# =#

using MPIClusterManagers, Distributed, CUDA, BenchmarkTools, ParameterizedNotebooks

mgr = MPIClusterManagers.start_main_loop(MPIClusterManagers.MPI_TRANSPORT_ALL)

nb = ParameterizedNotebook("talk.ipynb", sections=("Multi-GPU (multiple nodes, MPI, notebooks)",))
nb()

MPIClusterManagers.stop_main_loop(mgr)
