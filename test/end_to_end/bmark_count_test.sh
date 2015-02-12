#!/bin/bash

. end_to_end.sh "It accepts a count of runs in 'bmark' tests"

EXPECTED_OUTPUT=results/example.count.results

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
  mix bmark example | grep ":count test running 5 times" > /dev/null || fail "Did not run test"
}

function verify() {
  [ -f $EXPECTED_OUTPUT ] || fail "No results file $EXPECTED_OUTPUT"
  wc -l $EXPECTED_OUTPUT | grep "5" > /dev/null || fail "Wrong number of results"
  pass
}

main
