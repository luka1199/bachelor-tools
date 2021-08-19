#!/bin/bash
CURRENT_FOLDER=$(pwd)
MODULES_FOLDER=$1
MODULES_TO_TEST=$2
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_PATH="$SCRIPT_PATH/../.."
LOG_FILE="$MODULES_FOLDER/../test.log"

cd "$MODULES_FOLDER"
N=4
for MODULE in $(node $ROOT_PATH/tools/getModulesMissing.js $MODULES_TO_TEST ../test.log); do
    (
        echo ""
        echo ">> Testing $MODULE"

        cd "$MODULES_FOLDER/$MODULE/src"
        sudo timeout 120 npm run test
        CODE=$?
        if [[ $CODE -eq 0 ]]; then
            LOG_OUTPUT="OK"
        else
            if [ $CODE -eq 124 ]
            then
                LOG_OUTPUT="TIMEOUT"
            else
                LOG_OUTPUT="NOK"
            fi
        fi
        cd "$MODULES_FOLDER"

        echo "$MODULE - $LOG_OUTPUT" >>$LOG_FILE
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done
cd "$CURRENT_FOLDER"