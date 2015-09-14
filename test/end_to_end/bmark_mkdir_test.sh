#!/bin/bash

. end_to_end.sh "It creates a results directory if it does not exist"

function main() {
  cd ../../
  rm -rf results
  mix bmark example > /dev/null || fail "Did not run test"
  [ -d results ] || fail "Did not create results directory"
  pass
}

main
