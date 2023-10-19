#!/usr/bin/env bash

################################################################################
## File:  scripts/Example_Run_Parameters.bash
## 
## This file serves as documentation of the parameters.  It can also be used as
## a basis for a new run parameter file.  
################################################################################
##
################################################################################
## Parameters in this section must be declared.  There are no defaults.
################################################################################
##
## Change these to match your run segments and their properties.
##
## NOTE - these prefixes are important, and your filenames must match.
##
##        Make sure that your run control ('mdin') files are named like:
##
##                  Prefix[${i}].in
##
## See the Run_Parameters.bash file for the RoeProtocol for example use.
##
RunParts=( min relax produ ) # labels for your simulation steps
declare -a Prefix # filename prefixes for each step
Prefix=(
	[min]='gp_min'
	[relax]='gp_relax'
	[produ]='gp_production'
)
declare -a Description # Description of each step
Description=(
	[min]='Gas-Phase Minimization'
	[relax]='Gas-Phase Relaxation'
	[produ]='Gas-Phase Production'
)

################################################################################
##
## Variables in this section have defaults.  See the main script for defaults.
##
## Many variables can be specified in array form so that they change for each 
## step in the simulation.  
##
################################################################################
##
#########################################
## Arrays (dictionaries) in general
#########################################
##
## Aside from RunParts, Prefix and Description, which must be declared, some options can be single-valued or an array.
## If they are cast as an array, a default can be set. You can also specify that array values must be used.
## Internally, all these variables are turned into arrays.
##
## Names of these variables come in pairs, for example:
#   
#    simParameter  simParameterArr
#   
## The variable with the 'Arr' suffix is the array.  It must be a dictionary with the form of Prefix and Description. 
## That is, its keys must be the members of Runparts and be present in the order they appear in RunParts.
##
## If your dictionary values are all the same, there is no need to generate an array. In this case, just use the 
## non-array variable, like so:
#
#    simParameter="constantValue"
#
## This usage also applies if you want to have a default. In this exaple, 'min' gets a specified value, but 'relax'
## and 'produ' get the default value.
#
#    simParameter="defaultValue"
#
#    declare -a simParameterArr # an array/dictionary of simulation parameters
#    simParameterArr=(
#    	[min]='minimizationValue'
#    	[relax]=''
#    	[produ]=''
#    )
##
## If you want to ensure that only values in the array/dictionary are used, and that the program will fail if a value
## is not provided, set your parameter to 'VARIED'.
#
#    simParameter='VARIED'  # Special value meaning to strictly use array definitions.
#
#    declare -a simParameterArr 
#    simParameterArr=(
#    	[min]='minimizationValue'
#    	[relax]=''  # <--- will cause failure because not defined and 'VARIED' is used above
#    	[produ]='produValue'
#    )
##
##
##
############################
## Restraints
############################
## If you need restraints for your steps, this can be an array.  
## Valid values are:
## 	Initial = use the starting coordinates
##	NONE    = there are no restraints/reference-coords for this step
##	RunPart = one of the entries in 'RunParts'.
##
## In this example (which doesn't make a lot of physical sense and is just an 
## example), the minimization is restrained to the initial coordinates, the 
## relaxation phase is restrained to the coords in the restart file from the 
## RunPart called 'min'.  The production run has no restraints.
##
##	declare -a refCoordsArr
##	refCoordsArr=(
##		[min]='Initial'
##		[relax]='min'
##		[produ]='NONE'
##	)
##
## To have no restraints, simply say:
refCoords='NONE'
##
## To have the program fail if you have not declared your array (or have not declared it properly), use:
#  refCoords='VARIED'
##
###############################
## Tell the script how to get your AMBERHOME:
## Set thisAMBERHOME to DETECT if you want the script to try to detect it.
## Otherwise, set thisAMBERHOME to your AMBERHOME absolute path.
thisAMBERHOME='DETECT'
#thisAMBERHOME='/path/to/your/amber'
#
###############################
## Replace these with the names of your prmtop and inpcrd files
PRMTOP='structure.parm7'
INPCRD='structure.rst7'
#
###############################
## Choose the format for the initial input coordinates
initialCoordFormat="Amber7Rst"  ## Amber 7 Restart
#initialCoordFormat="NetCDF"  ## 
#
###############################
## Choose the output format for coordinates
## NOTE !  Make sure this matches the ntwo entry in your input files.  To use
##         this script, all files must use the same coordinate output format.
coordOutputFormat="NetCDF"  ## ntwo=2 - much smaller files; not human readable
#coordOutputFormat="ASCII"  ## ntwo=1 - larger file sizes; is human readable
#
###############################
## Choose either sander or pmemd as your MD engine
##    - sander is freely distributed with AmberTools, but isn't fast
##    - pmemd requires an AMBER license (prices are generally reasonable)
##      pmemd is much faster than sander, so use it if you have the choice
## Note - there can be only one mdEngine for a given call of this script.
mdEngine=pmemd
# mdEngine=sander
# mdEngineArr is enabled
##
###############################
## Will you be running your simulation in parallel ('useMpi')?
## NOTE! This is not the same as using CUDA (below).  It is possible to be
##      only parallel, only CUDA, both, or neither.
useMpi=Y
# useMpi=N
# useMpiArr is enabled
#
###############################
# If you chose Y for useMPI, specify the number of processors
# Replace '4' with your number of processors, if that is a different number
numProcs=4
# numProcsArr is enabled
##
###############################
## Will you be running your simulation using CUDA?
## We expect that more users will have ready access to plain MPI than to CUDA,
##       so we set the default to be no.
useCuda=N
# useCuda=Y
# useCudaArr is enabled
##
###############################
## Would you like this script to print out the job submission commands?
## These will be printed to outputFileName, below.
##     - Yes  = print the job submisison commands
##     - No   = do not print the job submisison commands
##     - Only = only print the job submisison commands; do NOT actually run 
##              the simulations (for troubleshooting)
writeCommands=Yes
# writeCommands=No
# writeCommands=Only
##  
###############################
## You can change the name of the output file if you like. 
## This file will contain a detailed log from the point of view of this script.
outputFileName='details.log'
##  
###############################
## You can change the name of the status file if you like. 
## This file will contain a terse log from the point of view of this script.
statusFileName='status.log'
##  
###############################
## The allowOverwrites variable controls whether the simulation will 
##      overwrite any pre-existing files.
## It is useful to set it to 'N' if you don't want a restarted simulation
##      to overwrite files that were already begun. 
allowOverwrites=Y
# allowOverwrites=N
# allowOverwritesArr is enabled
##
###############################
## If you are so inclined, you can change the output suffix, but these
## options are pretty standard, so leaving them as-is should be good for
## most applications.
if [ "${coordOutputFormat}" == "NetCDF" ] ; then
	restrtSuffix='restrt.nc'
	mdSuffix='nc'
elif [ "${coordOutputFormat}" == "ASCII" ] ; then
	restrtSuffix='rst7'
	mdSuffix='mdcrd'
else
	echo "Value of coordOutputFormat variable unrecognized.  Exiting."
	exit
fi
##
###############################
## Check to see if we are just testing the overall workflow.
## This can be set using the input file as described above.
## It can also be set using the environment variable MDUtilsTestRunWorkflow
## If MDUtilsTestRunWorkflow disagrees with testWorkflow, the
## value assigned to MDUtilsTestRunWorkflow will be used.
##
## If set, the script will set:
##               maxcyc, ncyc, ntwr and nstlim to 2.
## !!!! WARNING !!!! 
##      It will do this using sed.  The input files will be changed in place.  
##	If you need to keep the original values, save backups.
##    
testWorkflow=No
#testWorkflow=Yes
##
