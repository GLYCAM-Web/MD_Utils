#!/bin/bash
#SBATCH -J JOB_NAME
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --tasks-per-node=28

source /etc/profile.d/modules.sh

srun hostname -s | sort -u >slurm.hosts
export pmemd="mpirun -np 28 $AMBERHOME/bin/pmemd.MPI"
wallclock="Total wall time"

systemName=SYSTEM_NAME

#step 1
$pmemd -O -i 1.min.in -o 1.min.o -p $systemName.prmtop -c $systemName.rst7 -r 1.min.rst7 -ref $systemName.rst7
#step 2
if grep -q "$wallclock" 1.min.o ; then
$pmemd -O -i 2.relax.in -o 2.relax.o -p $systemName.prmtop -c 1.min.rst7 -r 2.relax.rst7 -ref $systemName.rst7
fi
#step 3
if grep -q "$wallclock" 2.relax.o ; then
$pmemd -O -i 3.min.in -o 3.min.o -p $systemName.prmtop -c 2.relax.rst7 -r 3.min.rst7 -ref $systemName.rst7
fi
#step 4
if grep -q "$wallclock" 3.min.o ; then
$pmemd -O -i 4.min.in -o 4.min.o -p $systemName.prmtop -c 3.min.rst7 -r 4.min.rst7 -ref $systemName.rst7
fi
#step 5
if grep -q "$wallclock" 4.min.o ; then
$pmemd -O -i 5.min.in -o 5.min.o -p $systemName.prmtop -c 4.min.rst7 -r 5.min.rst7
fi
#step 6
if grep -q "$wallclock" 5.min.o ; then
$pmemd -O -i 6.relax.in -o 6.relax.o -p $systemName.prmtop -c 5.min.rst7 -r 6.relax.rst7 -ref 5.min.rst7
fi
#step 7
if grep -q "$wallclock" 6.relax.o ; then
$pmemd -O -i 7.relax.in -o 7.relax.o -p $systemName.prmtop -c 6.relax.rst7 -r 7.relax.rst7 -ref 5.min.rst7
fi
#step 8
if grep -q "$wallclock" 7.relax.o ; then
$pmemd -O -i 8.relax.in -o 8.relax.o -p $systemName.prmtop -c 7.relax.rst7 -r 8.relax.rst7 -ref 5.min.rst7
fi
#step 9
if grep -q "$wallclock" 8.relax.o ; then
$pmemd -O -i 9.relax.in -o 9.relax.o -p $systemName.prmtop -c 8.relax.rst7 -r 9.relax.rst7
fi
#step 10
if grep -q "$wallclock" 9.relax.o ; then
$pmemd -O -i 10.produ.in -o 10.produ.o -p $systemName.prmtop -c 9.relax.rst7 -r 10.produ.rst7 -x produ.nc
fi

