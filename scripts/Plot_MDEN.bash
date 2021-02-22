#!/usr/bin/env bash
##
USAGE="
Usage:

    Plot_MDEN.bash file.mden [view] [Entry]

    where:

    	file.mden is the name of the mden file to plot.

		By default, the total energy (Etot) will
		be plotted vs the number of steps (Nsteps)
		and the plot will be saved as a jpeg file
		with name 'file.mden.Etot.jpeg'

	view (optional) is the literal word 'view'

		This will cause the plot to be sent to the
		screen rather than into a jpeg file.  This
		requires an interactive, graphical session.

	Entry is one of the entries as listed at the top of the 
		mden file.  Examples include Etot, Temp, volume.

		If an entry name is specified, then that entry
		will be plotted versus its instance number in
		the mden file. That is, if you use the keyword
		'volume', and there are 1500 entries for 'volume'
		in the file, then the x-axis values will start at 
		0 and proceed to 1500.

		See the first 10 lines of the mden file for the
		possible entries.  Ignore the first column (L0,
		L1, etc.), as these are not useful or plottable.
"
##
if [ "${1}zzz" == "zzz" ] ; then
	echo "${USAGE}"
	exit 1
fi

VIEW='No'
DEFAULTXY='Yes'
ENTRY='E_tot'

if [ "${2}zzz" != "zzz" ] ; then
	if [ "${2}" == "view" ] ; then 
		VIEW='Yes'
	else
		DEFAULTXY='No'
		ENTRY=${2}
	fi
fi
if [ "${3}zzz" != "zzz" ] ; then
	if [ "${3}" == "view" ] ; then 
		VIEW='Yes'
	else
		DEFAULTXY='No'
		ENTRY=${3}
	fi
fi
LINE_GREP=$(grep ${ENTRY} ${1})
LINE=${LINE_GREP:1:1}
LineWords=(${LINE_GREP})
## The following is copypasta from: 
## https://superuser.com/questions/434507/how-to-find-the-index-of-a-word-in-a-string-in-bash
cnt=0; 
for el in "${LineWords[@]}"; do
	[[ $el == "${ENTRY}" ]] && break
	((++cnt))
done

TITLE="Data from file ${1} on $(date)"
XLABEL="Nsteps"
YLABEL="${ENTRY//'_'/'\_'}"
TERMINAL="jpeg"
OUTPUT="${1}.${ENTRY}.jpeg"
VIEWPARTS="#
set terminal jpeg
set output '${OUTPUT}'
"
PLOTLINE="plot '${1}' every 10 using 2:4"
if [ ${DEFAULTXY} == "No" ] ; then
	XLABEL="Instance index"
	PLOTLINE="plot '${1}' every 10::${LINE} using 0:$((cnt+1))"
fi

GNUPLOTCOMMAND='gnuplot'
if [ "${VIEW}" == "Yes" ] ; then
	VIEWPARTS="#"
	GNUPLOTCOMMAND='gnuplot --persist'
fi

GNUPLOTFILE="${VIEWPARTS}
set title '${TITLE}'
set xlabel '${XLABEL}'
set ylabel '${YLABEL}'
${PLOTLINE}
"

echo "${GNUPLOTFILE}" | ${GNUPLOTCOMMAND}
