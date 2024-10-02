#!/bin/bash
#SBATCH -J JOBNAME
#SBATCH --partition=gm
#SBATCH --get-user-env
#SBATCH --output=slurmSimulation.out
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --gres=gpu:1

source /etc/profile.d/modules.sh
source /cm/shared/apps/amber20//amber.sh

bash Run_Multi-Part_Simulation.bash
