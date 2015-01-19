#!/bin/bash

. end_to_end.sh "bmark.cmp reports significant differences for disimilar results"

function main() {
  cd ../../
  mix bmark.cmp $(data similar1.results) $(data different.results) | grep "p < 0.0005" > /dev/null || fail
  pass
}

main