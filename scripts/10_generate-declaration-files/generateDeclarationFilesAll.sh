#!/bin/bash
SCRIPT_PATH="$(
    cd "$(dirname "$0")"
    pwd -P
)"

OUTPUT_FOLDER="$1"

LOG_FILE_NORMAL="$OUTPUT_FOLDER/../generate_declaration_file_normal.log"
rm -f $LOG_FILE_NORMAL
LOG_FILE_CLEANED="$OUTPUT_FOLDER/../generate_declaration_file_cleaned.log"
rm -f $LOG_FILE_CLEANED

rm -rf /tmp/results
mkdir /tmp/results

N=6
for MODULE_PATH in $OUTPUT_FOLDER/*; do
    MODULE=$(basename $MODULE_PATH)

    echo ">> $MODULE"
    
    timeout 100 ../../ts-declaration-file-generator-service/cli/generateDeclarationFile.sh $MODULE_PATH/normal/output_fixed.json $MODULE /tmp/results
    timeout 60 cp /tmp/results/$MODULE/index.d.ts $MODULE_PATH/normal/
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
    echo "$MODULE - $LOG_OUTPUT" >>$LOG_FILE_NORMAL
    rm -rf /tmp/results/$MODULE
    
    timeout 100 ../../ts-declaration-file-generator-service/cli/generateDeclarationFile.sh $MODULE_PATH/cleaned/output_fixed.json $MODULE /tmp/results
    timeout 60 cp /tmp/results/$MODULE/index.d.ts $MODULE_PATH/cleaned/
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
    echo "$MODULE - $LOG_OUTPUT" >>$LOG_FILE_CLEANED
    rm -rf /tmp/results/$MODULE
done
