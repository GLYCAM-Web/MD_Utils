#!/usr/bin/env bash

################################################################################
##
## This script will generate plots useful for checking equilibration progress.
##
## Gnuplot is required.  Also, you need an mden file from your simulation.
## You need to supply the mden name on the command line, like:
##
##           bash Check_Equil.bash mden
##
## If you issue this command:
##
##           bash Check_Equil.bash eq1.en
##
## ...the script will look for a file called eq1.en
##
## The plot will be in the form of a jpeg file.  If you know gnuplot at all,
## it should be easy for you to alter that behavior by changing this script.
##
## You can control what gets plotted by changing the following three
## variables.  They refer to contents of the mden file.
## The default values print Etot versus Nsteps.
## 
LineNumber=0  # the number after 'L' in the file
xField=2  # the number after 'L' in the file - set to '0' to use datum number
yField=4  # the number after 'L' in the file
##
################################################################################

grepText="L${LineNumber}"
dataFile="${1}_${grepText}"

grep ${grepText} ${1} > ${dataFile}

echo "#!/usr/bin/env gnuplot
set term jpeg
set output '${dataFile}.jpg'
plot '${dataFile}' using ${xField}:${yField}
" > ${dataFile}.gplt

gnuplot ${dataFile}.gplt
