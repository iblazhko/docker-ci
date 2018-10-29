#!/bin/bash

REPOSITORY_DIR="$1"

### Directory of this script
pushd . > /dev/null
SCRIPT_DIR="${BASH_SOURCE[0]}"
while([ -h "${SCRIPT_DIR}" ]); do
    cd "`dirname "${SCRIPT_DIR}"`"
    SCRIPT_DIR="$(readlink "`basename "${SCRIPT_DIR}"`")"
done
cd "`dirname "${SCRIPT_DIR}"`" > /dev/null
SCRIPT_DIR="`pwd`"
popd  > /dev/null

if  [ "${REPOSITORY_DIR}" = "" ]; then
    REPOSITORY_DIR=`realpath "${SCRIPT_DIR}/.."`
fi

if ! [ -d "${REPOSITORY_DIR}" ]; then
    echo "*** Directory {REPOSITORY_DIR} does not exist"
    exit 1
fi

### Start the purge
echo "*** Purging ${REPOSITORY_DIR}"

find "${REPOSITORY_DIR}" -depth -name "bin" -type d -exec rm -rf "{}" \;
find "${REPOSITORY_DIR}" -depth -name "obj" -type d -exec rm -rf "{}" \;
find "${REPOSITORY_DIR}" -depth -name "TestResults" -type d -exec rm -rf "{}" \;

find "${SCRIPT_DIR}" -maxdepth 1 -name "reports" -type d -exec rm -rf "{}" \;
find "${SCRIPT_DIR}" -maxdepth 1 -name "fake" -type d -exec rm -rf "{}" \;
find "${SCRIPT_DIR}" -maxdepth 1 -name ".fake" -type d -exec rm -rf "{}" \;
find "${SCRIPT_DIR}" -maxdepth 1 -name "build.fsx.lock" -type f -exec rm -f "{}" \;
