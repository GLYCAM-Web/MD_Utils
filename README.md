# Molecular Dynamics Utilities
A collection of scripts and input files that might be useful to persons
wishing to run molecular dynamics simulatons.  These utilities are made
to work well with downloads from GLYCAM-Web, but they should be usable
in other situations, possibly with minor adjustments.

## Organization 

We use directories to organize things.

scripts
: Contains executable scripts to do things such as start simulations.

inputs
: Contains sets of inputs for different types of simulations.

In general, information in _scripts_ will be related to information
in _inputs_.  For example, if a script refers to a set of mdin 
(molecular dynamics input file, AMBER style) files, those files 
will be somewhere in the _inputs_ directory.  The scripts will also
be somewhat general, too, being customizable with just a few
internal changes and able to use different sets of inputs.

For example, if you want to run a simulation that:
* Starts from a pre-minimized structure containing water.
* Relaxes the water first,
* Then relaxes everything,
* Then does a production run.

You would copy the file
_scripts/Run_Multi-Part_Simulation.bash_ 
and the three mdin files in 
_inputs/pre-minimized-separate-water-relaxation/_
into a directory with your pre-minimized parm7 and rst7 files.
Then, you edit the Run_Multi-Part_Simulation.bash file as 
needed for your situation and then run the file.

You might also find _scripts/Check_Equilibration.bash_ useful.

