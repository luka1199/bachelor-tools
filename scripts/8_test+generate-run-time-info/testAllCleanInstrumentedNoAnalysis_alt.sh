#!/bin/bash

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_PATH=$SCRIPT_PATH/../..
MODULES_FOLDER=$1
MODULES_TO_TEST=$2
LOG_FILE="$MODULES_FOLDER/../test_clean_instrumented_no_analysis.log"

# Load extracted jalangi without analysis
mkdir -p $MODULES_FOLDER/../node_modules/jalangiExtracted
cp $MODULES_FOLDER/../jalangiExtracted/jalangiPlain.js $MODULES_FOLDER/../node_modules/jalangiExtracted/jalangi.js

cd "$MODULES_FOLDER"
N=4
for MODULE in $(node $ROOT_PATH/tools/getModulesMissing.js $MODULES_TO_TEST ../test_instrumented_no_analysis.log); do
    (
        echo ""
        echo ">> Testing $MODULE with instrumentation"
        cd "$MODULES_FOLDER/$MODULE/lib_instrumented"
        timeout 100 npm run __test__
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