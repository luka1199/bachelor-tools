#!/bin/bash
CURRENT_FOLDER=$(pwd)
MODULES_FOLDER="$(pwd)/$1"

cd "$MODULES_FOLDER"
N=10
for MODULE in $(sed -n '1075,1922p' "../modulesTest.csv"); do
    (
        echo ""
        echo ">> Copying dependencies of $MODULE"

        # rm -rf "./$MODULE/lib_instrumented/node_modules"
        cp -p -r -n "./$MODULE/src/node_modules/" "./$MODULE/lib_instrumented/"
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done
cd "$CURRENT_FOLDER"