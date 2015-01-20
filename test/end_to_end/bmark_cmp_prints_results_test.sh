#!/bin/bash

. end_to_end.sh "bmark.cmp prints the results"

function main() {
  cd ../../
  mix compile > /dev/null
  mix bmark.cmp $(data simple.results) $(data different.results) > $(result_file)
  grep "12345" $(result_file) > /dev/null || fail
  grep "67890" $(result_file) > /dev/null || fail
  wc -l $(result_file) | grep 14 > /dev/null ||
    fail "Expected header + 10 lines of results + 2 lines of comparison"
  
  pass
}

main
