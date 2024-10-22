#!/usr/bin/env bash

# This file expects to be run from:
#   MD_Utils/tests/protocols/RoeProtcol/write-commands

inputs_Dir='inputs'
test_Dir='temp_test'
protocol_Dir='../../../../protocols/RoeProtocol'

## this should be overwritten in the test
export AMBERHOME='/dev/null'

mkdir -p ${test_Dir}
cp -L ${inputs_Dir}/* ${test_Dir}
cp -L ${protocol_Dir}/* ${test_Dir}


( cd ${test_Dir} && bash Run_Multi-Part_Simulation.bash )


# TODO - write a test to check output vs what is saved in correct_outputs
