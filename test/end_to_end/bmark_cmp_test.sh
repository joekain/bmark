#!/bin/bash

. end_to_end.sh "It has a task called bmark.cmp"

function main() {
  cd ../../
  mix bmark.cmp $(data similar1.results) $(data similar2.results) || fail
  pass
}

main