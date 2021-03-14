#!/usr/bin/env bash

################################################################################
##
## This file performs the standard system build and minimization for glycans
## built using the tools at GLYCAM-Web and associated software.
##
## AMBERHOME must be set as an environment variable.
##
################################################################################

LOGFILE='Minimize.log'
echo "Run log begin on $(date) " > ${LOGFILE}

( 
command -V srun >/dev/null 2>&1 &&
  ( 
  echo "This build appears to be running in a Slurm cluster.:" >> ${LOGFILE} 
  echo "The current host is $(hostname):" >> ${LOGFILE} 
  echo "The build will run on these hosts:" >> ${LOGFILE} 
  srun hostname -s | sort -u >slurm.hosts
  cat slurm.hosts >> ${LOGFILE}
  )
)

echo "Sourcing amber.sh " > ${LOGFILE}
source ${AMBERHOME}/amber.sh

echo "Running tleap to generate input files." >> ${LOGFILE}
tleap -f mol.leapin

echo "Running the Gas-Phase Minimization" >> ${LOGFILE}
bash Run_Multi-Part_Simulation.bash Gas-Min-Parameters.bash
returnvalue=$?
if [ "${returnvalue}" != "0" ] ; then
	echo "...Gas-Phase Minimization failed.  Exiting" >> ${LOGFILE}
	exit 1
else
	echo "...Gas-Phase Minimization appears to be complete on $(date)" >> ${LOGFILE}
fi


echo "
Building the solvated systems.
" >> ${LOGFILE}

echo "Running cpptraj to convert to convenient formats" >> ${LOGFILE}
cpptraj -i min-gas.cpptrajin

echo "Running tleap to build the Tip3P solvated structures" >> ${LOGFILE}
tleap -f mol-t3p.leapin

echo "Running tleap to build the Tip5P solvated structures" >> ${LOGFILE}
tleap -f mol-t5p.leapin

echo "
Running the solvated minimizations.
" >> ${LOGFILE}

echo "Running the Tip3P-Solvated Minimization" >> ${LOGFILE}
bash Run_Multi-Part_Simulation.bash T3P-Min-Parameters.bash
returnvalue=$?
if [ "${returnvalue}" != "0" ] ; then
	echo "...T3P Minimization failed.  Exiting" >> ${LOGFILE}
	exit 1
else
	echo "...T3P Minimization appears to be complete on $(date)" >> ${LOGFILE}
fi

echo "Running the Tip5P-Solvated Minimization" >> ${LOGFILE}
bash Run_Multi-Part_Simulation.bash T5P-Min-Parameters.bash
returnvalue=$?
if [ "${returnvalue}" != "0" ] ; then
	echo "...T5P Minimization failed.  Exiting" >> ${LOGFILE}
	exit 1
else
	echo "...T5P Minimization appears to be complete on $(date)" >> ${LOGFILE}
fi


