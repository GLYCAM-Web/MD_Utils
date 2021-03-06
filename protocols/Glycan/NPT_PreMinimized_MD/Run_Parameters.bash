#!/usr/bin/env bash

################################################################################
##
## This file holds parameters to be read into Run_Multi-Part_Simulation.bash
##
## Please see that script for documentation.
##
## Here, all parameters are explicitly set, even those left at defaults.
##
################################################################################

thisAMBERHOME='DETECT'
PRMTOP='mol_min_t3p.parm7'
INPCRD='mol_min_t3p.restrt.nc'
coordOutputFormat="NetCDF"  ## ntwo=2 - much smaller files; not human readable
restrtSuffix='restrt.nc'
mdSuffix='nc'
outputFileName='run_simulation.out'

mdEngine=pmemd
useMPI=Y
numProcs=4
useCUDA=N
allowOverwrite=N

writeCommands=Only

runPrefix[0]='relax1'
runPrefix[1]='relax2'
runPrefix[2]='md'
runDescription[0]='Water-only relaxation'
runDescription[1]='Full system relaxation (no restraints)'
runDescription[2]='MD production run'
