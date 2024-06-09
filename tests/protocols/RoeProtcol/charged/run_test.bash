#!/usr/bin/env bash
if [ -d tmpdir ] ; then
	rm -rf tmpdir
fi
mkdir tmpdir

cp -a inputs/* tmpdir/

cp ../../../../protocols/RoeProtocol/* tmpdir/

( cd tmpdir  && ./Run_Multi-Part_Simulation.bash  )

theDiffs="$(diff tmpdir/MD_unsolvated_rmsd.txt correct_outputs/MD_unsolvated_rmsd.txt)"

if [ "${theDiffs}" != "" ] ; then
	echo "the test failed"
else
	echo "the test passed"
fi


