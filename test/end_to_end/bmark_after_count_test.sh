#!/bin/bash

. end_to_end.sh "After a count with specified runs it runs 10 iterations"

EXPECTED_OUTPUT=results/example.after_count.results

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
  mix bmark example | grep ":after_count test running" > /dev/null || fail "Did not run test"
}

function verify() {
  [ -f $EXPECTED_OUTPUT ] || fail "No results file $EXPECTED_OUTPUT"
  wc -l $EXPECTED_OUTPUT | grep "10" > /dev/null || fail "Wrong number of results"
  pass
}

main
