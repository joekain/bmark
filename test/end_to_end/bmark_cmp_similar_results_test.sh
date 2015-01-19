#!/bin/bash

. end_to_end.sh "bmark.cmp reports no significant difference for similar results"

function main() {
  cd ../../
  mix bmark.cmp $(data similar1.results) $(data similar2.results) | grep "p < 1" > /dev/null || fail
  pass
}

main