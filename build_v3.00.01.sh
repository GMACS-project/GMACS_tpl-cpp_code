#!/bin/sh
echo on
DIR="$( cd "$( dirname "$0" )" && pwd )"
cd ${DIR}
cp gmacsbase_v3.00.01.TPL gmacsbase.TPL
cd ./_build
rm gmacs.tpl; make;
cd ${DIR}

