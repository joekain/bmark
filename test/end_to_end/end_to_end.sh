#!/bin/bash

function init () {
  load_config
  set_test_name $*
}

function set_test_name() {
  if [ -n "$1" ]; then
    export END_TO_END_TEST_NAME=$*
  else
    export END_TO_END_TEST_NAME="Unnamed test"
  fi  
}

function load_config() {
  [ -f "./end_to_end_config.sh" ] && . ./end_to_end_config.sh
  [ -n "$END_TO_END_TEST_DIR" ]   || config_fail "Set configuration for END_TO_END_TEST_DIR"
  [ -n "$END_TO_END_DATA_DIR" ]   || config_fail "Set configuration for END_TO_END_DATA_DIR"
  [ -n "$END_TO_END_GOLD_DIR" ]   || config_fail "Set configuration for END_TO_END_GOLD_DIR"
  [ -n "$END_TO_END_OUTPUT_DIR" ] || config_fail "Set configuration for END_TO_END_OUTPUT_DIR"
}

function config_fail() {
  echo -e $(red Configuration Error:) $*
  exit -1
}

function pass () {
  echo -e $(green PASS:) $END_TO_END_TEST_NAME
  exit 0
}

function fail () {
  echo -e $(red FAIL:) $END_TO_END_TEST_NAME $(red $*)
  exit -1
}

function green () {
  TEXT=$1
  echo "\033[1;32m$TEXT\033[0m"
}

function red () {
  TEXT=$*
  echo "\033[1;31m$TEXT\033[0m"
}

function result_file () {
  mkdir -p test_data
  echo "$END_TO_END_OUTPUT_DIR/temp"
}

function data () {
  echo "$END_TO_END_DATA_DIR/$1"
}

function gold () {
  echo "$END_TO_END_GOLD_DIR/$1"
}

function end_to_end_runner () {
  echo "\nEnd-to-end Tests:"
  for test in $END_TO_END_TEST_DIR/*_test.sh ; do
    $test
  done
  
  if [ "$1" == "--pending" -a -e $END_TO_END_TEST_DIR/*_test_p.sh ]; then
    echo "\nPending Integration Tests:"
    for test in $END_TO_END_TEST_DIR/*_test_p.sh ; do
      $test
    done
  fi
}

init $*
