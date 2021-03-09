Molecular Dynamics Input (mdin) File Series

The files herein encode a simulation with a minimization and two separate 
relaxation steps followed by a production run.  That makes four parts, and 
there is one mdin file per part.  These files assume that the system 
contains a solute and a solvent.  The system might also contain ions.  

The four parts of the simulation are:

1. min.in:  Full system minimization.
2. relax1.in:  Relaxation of the water water molecules and the hydrogen atoms 
   only.  During this part of the simulation, the heavy atoms in the solvent, 
   and any ions, if they are present, are held still. 
3. relax2.in:  Relaxation of the entire system (no restraints on motion).
4. md.in:  A production run, from which data might be gathered. 

Furthermore, these files specify that the system, among other things:

* Is in the isothernal, isobaric (NPT) ensemble.  The temperature is held 
  constant at 300.0 Kelvin and the pressure is 1.0 torr.
* Has periodic boundary conditions. 
* Holds constant the lengths of bonds including hydrogen.

Persons wishing to understand the meanings of all the parameters included
in the mdin files are encouraged to consult the 
[AMBER manual] (https://ambermd.org/doc12/Amber20.pdf).  
The meanings of the parameters can be subtle and complex.

A novice researcher might change the following parameters with
relative safety.

*  nstlim : The total number of simulation steps to perform.  Together
            with 'dt', this parameter determines the total simulated time.
*  ntwx   : The frequency with which system coordinates are written to 
            the coordinate file.  It can be difficult to know ahead of time
            the proper frequency to use.  If you save too often, you can 
            use a lot of storage.  If you save too infrequently,
            you might miss important system behaviors.  Think of the 
            coordinates as being analogous to time-lapsed photos.
*  ntpr   : The frequency with which to print energy and other information 
            to the output (mdout) file and to the current-status-info (mdinfo) 
            files.  The smaller this number, the more often you can get
            updates about how your simulation is going, but also the 
            larger your mdout file gets.
*  ntave  : The frequency with which to print averages of energies and other
            values to the mdout file.  Averages are taken over the last ntave 
            steps.  
*  ntwe   : The fequency with which energy, and other, values are printed to 
            the mden file.  Note that these values are not printed so that
            they easily correspond to the coordinates (see ntwx).  However,
            the values in this file are relatively easy to parse for plotting, 
            so they are convenient for doing quick checks of relaxation 
            and for tests of certain types of convergence.

A novice researcher might change the following, but with caution.

*  temp0  : The target constant temperature.  Care should be taken if changing
            the temperature more than a few degrees.  The force fields used in
            MD are typically developed for temperatures at or near 300.0 K.  To 
            use the force fields at significantly different temperatures
            requires validation to ensure that the force field behaves 
            adequately (for the research needs) at the other temperature. 
*  ioutfm : The format of coordinate, and certain other, files.  When set to 
            '0', the output is in a human-readable, ASCII format.  If set to
            '1', the output is in a more compressed, generally superior, but
            not human readable, NetCDF format.
*  iwrap  : Flag for wrapping coordinates back into the primary periodic box
            or, alternately, allowing the atoms to proceed along trajectories
            outside box boundaries.  Depending on the needs of the researcher, 
            one or the other might be best.  Unless you are tracking diffusion 
            or a related property, you probably to allow wrapping by setting
            this to '1'.  Otherwise, let the atoms fly freely by setting 
            this to '0'.

No matter how tempting, novice researchers should not change:
 
*  dt     : This sets the time step.  If you know what you're doing, or if an
            expert you trust says to, you can change it.  Otherwise, don't.

Other trivia:

* ntb     : Largely deprecated, the flag to turn periodic boundaries on or 
            off, and how to set them.  This flag no longer needs to be 
            explicitly set: the software will figure out what the value should 
            be.  Only in certain strange situations should it need to be set.  
            The current recommendation is to not set it.  However, these files
            might be used with older AMBER versions, so it is set here.

