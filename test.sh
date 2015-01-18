#!/bin/sh

mix test || exit -1

cd test/end_to_end
. ./end_to_end.sh
end_to_end_runner $*
