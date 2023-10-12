#!/bin/bash
#SBATCH -C gpu -q regular -A mp107
#SBATCH -t 00:05:00 
#SBATCH --cpus-per-task 32 --gpus-per-task 1 --ntasks-per-node 4 --nodes 4
#=
srun /global/u1/m/marius/.julia/juliaup/julia-1.9.3+0.x64.linux.gnu/bin/julia $(scontrol show job $SLURM_JOBID | awk -F= '/Command=/{print $2}')
exit 0
# =#

using MPIClusterManagers, Distributed, CUDA, BenchmarkTools

mgr = MPIClusterManagers.start_main_loop(MPIClusterManagers.MPI_TRANSPORT_ALL)

let
    carr = cu(rand(10_000_000))
    pmap(WorkerPool(procs()), 1:nprocs()) do i
        @btime CUDA.@sync sin.($carr) .+ 1
    end
end

MPIClusterManagers.stop_main_loop(mgr)
