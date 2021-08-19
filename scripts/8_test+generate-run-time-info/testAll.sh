#!/bin/bash
CURRENT_FOLDER=$(pwd)
MODULES_FOLDER=$1
MODULES_TO_TEST=$2
LOG_FILE="$MODULES_FOLDER/../test.log"
ERROR_LOG_FILE="$MODULES_FOLDER/../test_errors.log"
rm -f $LOG_FILE
rm -f $ERROR_LOG_FILE

cd "$MODULES_FOLDER"
N=4
for MODULE in $(cat "$MODULES_TO_TEST"); do
    (
        echo ""
        echo ">> Testing $MODULE"

        cd "$MODULES_FOLDER/$MODULE/src"
        sudo timeout 100 npm run test
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