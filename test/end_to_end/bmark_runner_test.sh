#!/bin/bash

. end_to_end.sh "It runs 'bmark' functions from the bmark/ directory"

EXPECTED_OUTPUT=results/example.runner.results

function main() {
  cd ../../
  cleanup
  run_example
  verify
}

function cleanup() {
  rm -f $EXPECTED_OUTPUT
}

function run_example() {
  mix bmark example > /dev/null || fail
}

function verify() {
  [ -f $EXPECTED_OUTPUT ] || fail "No results file $EXPECTED_OUTPUT"
  pass
}

main