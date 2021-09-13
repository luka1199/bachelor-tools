#!/bin/bash
SCRIPT_PATH="$(
    cd "$(dirname "$0")"
    pwd -P
)"

OUTPUT_FOLDER="$1"
LOG_FILE_NORMAL="$OUTPUT_FOLDER/../validate_analysis_normal.log"
LOG_FILE_CLEANED="$OUTPUT_FOLDER/../validate_analysis_cleaned.log"
rm -f $LOG_FILE_NORMAL
rm -f $LOG_FILE_CLEANED
touch $LOG_FILE_NORMAL
touch $LOG_FILE_CLEANED

N=4
for MODULE_PATH in $OUTPUT_FOLDER/*; do
    (
        MODULE=$(basename $MODULE_PATH)
        echo ">> $MODULE"
        echo "$MODULE - $(node $SCRIPT_PATH/../../tools/validateAnalysisJson.js $MODULE_PATH/normal/output.json)" >> $LOG_FILE_NORMAL
        echo "$MODULE - $(node $SCRIPT_PATH/../../tools/validateAnalysisJson.js $MODULE_PATH/cleaned/output.json)" >> $LOG_FILE_CLEANED
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done
