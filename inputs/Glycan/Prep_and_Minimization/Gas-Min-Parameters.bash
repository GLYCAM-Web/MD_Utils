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
PRMTOP='mol.parm7'
INPCRD='mol.rst7'
coordOutputFormat="NetCDF"  ## ntwo=2 - much smaller files; not human readable
restrtSuffix='restrt.nc'
mdSuffix='nc'
outputFileName='gas_phase_minimization.out'

mdEngine=sander
useMPI=Y
numProcs=2
useCUDA=N
allowOverwrite=N

writeCommands=Only

runPrefix[0]='min-gas'
runDescription[0]='Gas-phase minimization'
