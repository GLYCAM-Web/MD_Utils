#!/usr/bin/env bash

################################################################################
## File:  Run_Multi-Part_Simulation.bash
################################################################################
##
## This script will run one or more MD simulations for you using AMBER
##
## This script expects to find run information in a file called:
##
## 	Run_Parameters.bash
##
## ...in your current directory 
##
## You may change the filename by:
##
##      - Setting the environment variable called 'GW_RUN_PARAMETERS' so 
##        that it points to whatever file you like.
##
##      - Adding the file name (with path if needed) as an argument on the
##        command line
##
## Additionally, you may override entries in Run_Parameters.bash by creating a
## file called Local_Run_Parameters.bash
##
## Documentation of the file Run_Parameters.bash can be found in the file:
##
##	scripts/Example_Run_Parameters.bash
##
if [ "${GW_RUN_PARAMETERS}zzz" == "zzz" ] ; then
	GW_RUN_PARAMETERS="./Run_Parameters.bash"
fi
if [ "${1}zzz" != "zzz" ] ; then
	GW_RUN_PARAMETERS="${1}"
fi
##
##
################################################################################
## Some parameters must be declared.  See the Example_Run_Parameters.bash file.
################################################################################
##
################################################################################
## Parameters that have defaults start here.  These can be overridden.
################################################################################
##
##
ReferenceCoordinates='NONE'
thisAMBERHOME='DETECT'
PRMTOP='structure.parm7'
INPCRD='structure.rst7'
coordOutputFormat="NetCDF"  
mdEngine=pmemd
useMPI=Y
numProcs=4
useCUDA=N
writeCommands=Yes
outputFileName='details.log'
statusFileName='status.log'
allowOverwrite=Y
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
testWorkflow=No
##
##
##
################################################################################
## This is the end of the parameters that have defaults.
##
## Normal users should not need to read or change anything below this line.
################################################################################

################################################################################
echo "$(date) : Simulation setup is starting." > ${statusFileName}
# Read in the Run Parameters file
if [ -f "${GW_RUN_PARAMETERS}" ] ; then
	. ${GW_RUN_PARAMETERS}
else
	echo "The run parameters file, '${GW_RUN_PARAMETERS}', was not found."
	echo "This file must be present. Exiting."
	exit 1
fi
if [ "${MDUtilsTestRunWorkflow}" == "Yes" ] ; then
	testWorkflow=Yes
fi
echo "TEST WORKFLOW IS: ${testWorkflow}"
##
################################################################################
## Checking for parameters that must be declared.
weshouldexit="No"
if [ "${RunParts}zzz" == "zzz" ] ; then
	echo "RunParts must be declared."
	weshouldexit="Yes"
fi
for part in ${RunParts[@]} ; do
	if [ "${Prefix[${part}]}zzz" == "zzz" ] ; then
		echo "The Prefix for part ${part} must be declared."
		weshouldexit="Yes"
	fi
	if [ "${Description[${part}]}zzz" == "zzz" ] ; then
		echo "The Description for part ${part} must be declared."
		weshouldexit="Yes"
	fi
done
if [ "${weshouldexit}" == "Yes" ] ; then
	echo "Exiting now."
	exit 1
fi
##
# Start the ouput file
echo "Beginning MD simulations on $(date)" | tee ${outputFileName}
echo "Working directory is $(pwd)" | tee -a ${outputFileName}
echo "Using info from file: '${GW_RUN_PARAMETERS}'. " | tee -a ${outputFileName}

##
##
# Source needed information from AMBERHOME
##
# First, see if an AMBERHOME is defined in the environment
if [ "${AMBERHOME}zzz" == "zzz" ] ; then
	amberhomeDefined='No'
else
	amberhomeDefined='Yes'
fi
# If we were instructed to detect AMBERHOME, 
detectAMBERHOME='No'
if [ "${thisAMBERHOME}" == "DETECT" ] ; then 
	detectAMBERHOME='Yes'
	if [ "${amberhomeDefined}" == "Yes" ] ; then
		thisAMBERHOME=${AMBERHOME}
	else
		echo "Could not Detect AMBERHOME.  Exiting." | tee -a ${outputFileName}
		exit 1
	fi
fi
if [ ! -d ${thisAMBERHOME} ] ; then
echo "
!!!!!!!!!!!!!!!  
Strong Warning 
!!!!!!!!!!!!!!!  
Cannot find AMBERHOME.  This is likely to cause problems if this is an attempt 
to actually run a simulation (as opposed to a test of the script, for example).
The script thinks that the following is AMBERHOME:
${thisAMBERHOME}
" | tee -a ${outputFileName}
if [ "${detectAMBERHOME}" == "No" ] ; then
	if [ "${amberhomeDefined}" == "Yes" ] ; then
		echo "The environment defines AMBERHOME as: ${AMBERHOME}
		" | tee -a ${outputFileName}
	fi
fi
fi
AMBERHOME=${thisAMBERHOME}
if [ -e ${AMBERHOME}/amber.sh ] ; then
	source ${AMBERHOME}/amber.sh
fi

##
# Set the contents of checkText according to the MD Engine
if [ "${mdEngine}" == "pmemd" ] ; then 
	checkText='Total wall time'
	useLogFile=Y
elif [ "${mdEngine}" == "sander" ] ; then 
	checkText='wallclock() was called'
	useLogFile=N
else
	echo "mdEngine other than pmemd or sander was specified.  Exiting." | tee -a ${outputFileName}
fi
echo "
The mdEngine is ${mdEngine} and the text to check for success is '${checkText}'." | tee -a ${outputFileName}

##
# Set the runs to use CUDA if requested
if [ "${useCUDA}" == "Y" ] ; then 
	if [ "${mdEngine}" != "pmemd" ] ; then 
		echo "mdEngine other than pmemd requested with CUDA.  Exiting." | tee -a ${outputFileName}
	fi
	mdEngine="${mdEngine}.cuda"
fi

##
# Set the runs to use MPI if requested
if [ "${useMPI}" == "Y" ] ; then 
	mdEngine="mpirun ${mdEngine}.MPI -np ${numProcs} "
fi

##
# Set the runs to allow overwriting if requested
if [ "${allowOverwrite}" == "Y" ] ; then 
	mdEngine="${mdEngine} -O "
fi


## Tell everyone what the complete mdEngine command is:
echo "Complete mdEngine command is '${mdEngine}'." | tee -a ${outputFileName}

## See if we need to provide reference coordinates for restraints
if [ "${ReferenceCoordinates}" != "NONE" ] ; then
	useRefCoords="Y"
fi

echo "
There will be ${#RunParts[@]} phases to this simulation:
" | tee -a ${outputFileName}


declare -A Commands
thisRestart="${INPCRD}"
i=1
for part in "${RunParts[@]}" ; do
	echo """Phase ${i} 
	- is called ${part} 
	- has prefix ${Prefix[${part}]} 
	- is described as: ${Description[${part}]}""" | tee -a ${outputFileName}
	i=$((i+1))

	COMMAND="${mdEngine} \
 -i ${Prefix[${part}]}.in \
 -o ${Prefix[${part}]}.o \
 -e ${Prefix[${part}]}.en \
 -p ${PRMTOP} \
 -c ${thisRestart} \
 -r ${Prefix[${part}]}.${restrtSuffix} \
 -x ${Prefix[${part}]}.${mdSuffix} \
 -inf ${Prefix[${part}]}.info "

	if [ "${useLogFile}" == "Y" ] ; then
		COMMAND="${COMMAND} -l ${Prefix[${part}]}.log "
	fi

	if [ "${useRefCoords}" == "Y" ] ; then
		if [ "${ReferenceCoordinates[${part}]}" != "NONE" ] ; then
			if [ "${ReferenceCoordinates[${part}]}" == "Initial" ] ; then
				thisRefCoords="${INPCRD}"
			else
				thisRefPart="${ReferenceCoordinates[${part}]}"
				thisRefCoords="${Prefix[${thisRefPart}]}.${restrtSuffix}"
			fi
			COMMAND="${COMMAND} -ref ${thisRefCoords}"
		fi
	fi

	Commands[${part}]="${COMMAND}"
	thisRestart=${Prefix[${part}]}.${restrtSuffix}
done

#for part in ${RunParts[@]} ; do
#	echo "This is the command for part ${part}"
#	echo "${Commands[${part}]}"
#done
#
#echo "REMOVE ME"
#exit
echo "$(date) : Simulation setup is complete." >> ${statusFileName}
if [ "${writeCommands}" != "Only" ] ; then
	echo "$(date) : Starting the ${#RunParts[@]} phases of this simulation." >> ${statusFileName}
else
	echo "$(date) : Writing commands only for the ${#RunParts[@]} phases of this simulation." >> ${statusFileName}
fi

##  Do the runs
#
for part in ${RunParts[@]} ; do
	echo "
	Starting phase ${part}" | tee -a ${outputFileName}

	COMMAND="${Commands[${part}]}"
	
	if [ "${testWorkflow}" == "Yes" ] ; then
		sed -i s/maxcyc\ *=\ *[1-9][0-9]*/maxcyc\ =\ 2/ ${Prefix[${part}]}.in 
		sed -i s/ncyc\ *=\ *[1-9][0-9]*/ncyc\ =\ 2/ ${Prefix[${part}]}.in 
		sed -i s/nstlim\ *=\ *[1-9][0-9]*/nstlim\ =\ 2/ ${Prefix[${part}]}.in 
		sed -i s/ntpr\ *=\ *[1-9][0-9]*/ntpr\ =\ 2/ ${Prefix[${part}]}.in 
		sed -i s/ntwe\ *=\ *[1-9][0-9]*/ntwe\ =\ 2/ ${Prefix[${part}]}.in 
		sed -i s/ntwx\ *=\ *[1-9][0-9]*/ntwx\ =\ 2/ ${Prefix[${part}]}.in 
		sed -i -E s/ntwr\ *=\ *-?[1-9][0-9]*/ntwr\ =\ 2/ ${Prefix[${part}]}.in 
	fi
	#
	#  Write it to a file if desired
	if [ "${writeCommands}" != "No" ] ; then
		echo "
		The command is:
		${COMMAND}

		" | tee -a ${outputFileName}
	fi
	#
	#  Run the command unless told not to 
	if [ "${writeCommands}" != "Only" ] ; then
		echo "$(date) : Starting phase ${part}." >> ${statusFileName}
		eval ${COMMAND}
		#
		# Check if the command worked
		if ! grep -q "$wallclock" ${Prefix[${part}]}.o ; then
			echo "

Something went wrong for run phase ${part}.
The simulation cannot continue.  Exiting.

"  | tee -a ${outputFileName}
			echo "$(date) : Simulation has failed on phase ${part}." >> ${statusFileName}
			exit 1
		fi
		echo "$(date) : Phase ${part} finished normally." >> ${statusFileName}
	fi

done

