#!/usr/bin/env bash

################################################################################
##
## This file holds parameters to be read into Run_Multi-Part_Simulation.bash
##
## Please see that script for documentation.
##
## Here, all parameters are explicitly set, even those left at defaults.
##
## The defaults correspond to simulations run via GLYCAM-Web.
##
## Values in this file can be overridden in a file called 
##        Local_Run_Parameters.bash
## This file is included at the bottom of this file, if it is found.
##
################################################################################

thisAMBERHOME='DETECT'
PRMTOP='MdInput.parm7'
INPCRD='MdInput.rst7'
initialCoordFormat='Amber7Rst'   ## Amber 7 restart
coordOutputFormat='NetCDF'  ## ntwo=2 ; much smaller files ; not human readable

mdEngine='pmemd'
useMpi='N'
numProcs=1
useCuda='Y'
allowOverwrites='N'

writeCommands='Yes'

RunParts=( min01 relax02 min03 min04 min05 relax06 relax07 relax08 relax09 produ10 )

declare -A Prefix
Prefix=(
	[min01]='01.min'
	[relax02]='02.relax'
	[min03]='03.min'
	[min04]='04.min'
	[min05]='05.min'
	[relax06]='06.relax'
	[relax07]='07.relax'
	[relax08]='08.relax'
	[relax09]='09.relax'
	[produ10]='10.produ'
	)
declare -A Description
Description=(
	[min01]='Minimize water and hydrogens, restraint_wt=5.0'
	[relax02]='Relax water and hydrogens, restraint_wt=5.0'
	[min03]='Minimize water and hydrogens, restraint_wt=2.0'
	[min04]='Minimize water and hydrogens, restraint_wt=0.1'
	[min05]='Minimize all, no restraints'
	[relax06]='Relax water and hydrogens, restraint_wt=1.0'
	[relax07]='Relax water and hydrogens, restraint_wt=0.5'
	[relax08]='Relax all except Glycan rings and protein backbone, restraint_wt=0.5'
	[relax09]='Relax full system, no restraints'
	[produ10]='MD production run'
	)
#declare -A mdEngineArr
#mdEngineArr=(
#	[min01]='pmemd'
#	[relax02]='pmemd'
#	[min03]='pmemd'
#	[min04]='pmemd'
#	[min05]='pmemd'
#	[relax06]='pmemd'
#	[relax07]='pmemd'
#	[relax08]='pmemd'
#	[relax09]='pmemd'
#	[produ10]='pmemd'
#	)
#declare -A useCudaArr
#useCudaArr=(
#	[min01]='Y'
#	[relax02]='Y'
#	[min03]='Y'
#	[min04]='Y'
#	[min05]='Y'
#	[relax06]='Y'
#	[relax07]='Y'
#	[relax08]='Y'
#	[relax09]='Y'
#	[produ10]='Y'
#	)
#declare -A useMpiArr
#useMpiArr=(
#	[min01]='N'
#	[relax02]='N'
#	[min03]='N'
#	[min04]='N'
#	[min05]='N'
#	[relax06]='N'
#	[relax07]='N'
#	[relax08]='N'
#	[relax09]='N'
#	[produ10]='N'
#	)
#declare -A allowOverwritesArr
#allowOverwritesArr=(
#	[min01]='N'
#	[relax02]='N'
#	[min03]='N'
#	[min04]='N'
#	[min05]='N'
#	[relax06]='N'
#	[relax07]='N'
#	[relax08]='N'
#	[relax09]='N'
#	[produ10]='N'
#	)
## This can be defined if MPI is used
#declare -A numProcsArr
#numProcsArr=(
#	[min01]=''
#	[relax02]=''
#	[min03]=''
#	[min04]=''
#	[min05]=''
#	[relax06]=''
#	[relax07]=''
#	[relax08]=''
#	[relax09]=''
#	[produ10]=''
#	)
## This can be defined if needed
#declare -A checkTextArr
#checkTextArr=(
#	[min01]=''
#	[relax02]=''
#	[min03]=''
#	[min04]=''
#	[min05]=''
#	[relax06]=''
#	[relax07]=''
#	[relax08]=''
#	[relax09]=''
#	[produ10]=''
#	)
declare -A refCoordsArr
refCoordsArr=(
	[min01]='Initial'
	[relax02]='Initial'
	[min03]='Initial'
	[min04]='Initial'
	[min05]='NONE'
	[relax06]='min05'
	[relax07]='min05'
	[relax08]='min05'
	[relax09]='NONE'
	[produ10]='NONE'
	)


if [ -f "Local_Run_Parameters.bash" ] ; then
	echo "found local info file"
	. Local_Run_Parameters.bash
fi
