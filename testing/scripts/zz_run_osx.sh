#!/bin/sh
echo on
DIR="$( cd "$( dirname "$0" )" && pwd )"
cd ${DIR}
./gmacs  -rs -nox  -nohess &&extra

