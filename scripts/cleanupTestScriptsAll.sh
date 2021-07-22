#!/bin/bash
CURRENT_FOLDER=$(pwd)
MODULES_FOLDER="$(pwd)/$1"
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_PATH=$SCRIPT_PATH/..

cd "$MODULES_FOLDER"
N=4
for MODULE in $(cat "../modulesTest.csv"); do
    (
        echo ""
        echo ">> Cleaning up $MODULE test script"

        cd "$MODULES_FOLDER/$MODULE/lib_instrumented"
        node $ROOT_PATH/tools/cleanupTestScript.js ./package.json
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done
cd "$CURRENT_FOLDER"