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
## ...that is included at the bottom of this file, if it is found.
##
################################################################################

thisAMBERHOME='DETECT'
PRMTOP='MdInput.parm7'
INPCRD='MdInput.rst7'
initialCoordFormat='Amber7Rst'   ## Amber 7 restart
coordOutputFormat='NetCDF'  ## ntwo=2 ; much smaller files; not human readable

mdEngine='pmemd'
useMPI='N'
numProcs=1
useCUDA='Y'
allowOverwrite='N'

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
declare -A ReferenceCoordinates
ReferenceCoordinates=(
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
