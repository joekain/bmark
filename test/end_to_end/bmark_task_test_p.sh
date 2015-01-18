#!/bin/bash

. end_to_end.sh "It has a Mix task named 'bmark'"

cd ../../
mix help bmark || fail
pass