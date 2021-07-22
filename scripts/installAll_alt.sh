#!/bin/bash

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_PATH="$( cd "$(dirname "$0")" ; pwd -P )/.."
CURRENT_FOLDER=$(pwd)
MODULES_FOLDER="$(pwd)/$1"
LOG_FILE="$MODULES_FOLDER/../install.log"

cd "$MODULES_FOLDER"
N=4
for MODULE in $(node $ROOT_PATH/tools/getModulesMissing.js ../modulesInstall.csv ../install.log); do
    (
        echo ""
        echo ">> Installing dependencies of $MODULE"

        cd "$MODULES_FOLDER/$MODULE/src"
        timeout 100 npm install
        CODE=$?
        if [[ $CODE -eq "0" ]]; then
            LOG_OUTPUT="OK"
            cd "$MODULES_FOLDER"
            rm -rf "$MODULES_FOLDER/$MODULE/lib_instrumented/node_modules"
            cp -r "$MODULES_FOLDER/$MODULE/src/node_modules/" "$MODULES_FOLDER/$MODULE/lib_instrumented"
        else
            if [[ $CODE -eq "124" ]]; then
                LOG_OUTPUT="TIMEOUT"
            else
                LOG_OUTPUT="NOK"
            fi
        fi
        
        echo "$MODULE - $LOG_OUTPUT" >>$LOG_FILE
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done
cd "$CURRENT_FOLDER"
