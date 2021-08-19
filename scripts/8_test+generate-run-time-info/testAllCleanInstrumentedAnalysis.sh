#!/bin/bash

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_PATH=$SCRIPT_PATH/../..
MODULES_FOLDER=$1
MODULES_TO_TEST=$2
LOG_FILE="$MODULES_FOLDER/../test_clean_instrumented_analysis.log"
rm -f $LOG_FILE

# Load extracted jalangi without analysis
mkdir -p $MODULES_FOLDER/../node_modules/jalangiExtracted
cp $MODULES_FOLDER/../jalangiExtracted/jalangi.js $MODULES_FOLDER/../node_modules/jalangiExtracted/jalangi.js

rm -rf /tmp/output.json
cd "$MODULES_FOLDER"
N=4
for MODULE in $(cat "$MODULES_TO_TEST"); do
    (
        echo ""
        echo ">> Testing $MODULE with instrumentation"
        cd "$MODULES_FOLDER/$MODULE/lib_instrumented"
        sudo timeout 100 npm run __test__
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
        mkdir -p "$MODULES_FOLDER/../output/$MODULE/cleaned"
        sudo cp "/tmp/output.json" "$MODULES_FOLDER/../output/$MODULE/cleaned/"
        cd "$MODULES_FOLDER"

        echo "$MODULE - $LOG_OUTPUT" >>$LOG_FILE
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done
cd "$CURRENT_FOLDER"