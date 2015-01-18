function init () {
  if [ -n "$1" ]; then
    export END_TO_END_TEST_NAME=$*
  else
    export END_TO_END_TEST_NAME="Unnamed test"
  fi
}

function pass () {
  echo $(green PASS:) $END_TO_END_TEST_NAME
  exit 0
}

function fail () {
  echo $(red FAIL:) $END_TO_END_TEST_NAME $(red $*)
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
  echo "test_data/temp"
}

function gold () {
  echo "test_data/$1"
}

function end_to_end_runner () {
  echo "\nEnd-to-end Tests:"
  for test in integration/*_test.sh ; do
    $test
  done
  
  if [ "$1" == "--pending" -a -e integration/*_test_p.sh ]; then
    echo "\nPending Integration Tests:"
    for test in integration/*_test_p.sh ; do
      $test
    done
  fi
}

init $*
