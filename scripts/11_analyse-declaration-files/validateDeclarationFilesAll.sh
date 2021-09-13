#!/bin/bash
SCRIPT_PATH="$(
    cd "$(dirname "$0")"
    pwd -P
)"

RESULTS_FOLDER="$1"
LOG_FILE_NORMAL="$RESULTS_FOLDER/../validate_declaration_files_normal.log"
LOG_FILE_CLEANED="$RESULTS_FOLDER/../validate_declaration_files_cleaned.log"
rm -f $LOG_FILE_NORMAL
rm -f $LOG_FILE_CLEANED
touch $LOG_FILE_NORMAL
touch $LOG_FILE_CLEANED

N=4
for MODULE_PATH in $RESULTS_FOLDER/*; do
    (
        MODULE=$(basename $MODULE_PATH)
        echo ">> $MODULE"
        echo "$MODULE - $(node $SCRIPT_PATH/../../tools/validateDeclarationFile.js $MODULE_PATH/normal/index.d.ts)" >> $LOG_FILE_NORMAL
        echo "$MODULE - $(node $SCRIPT_PATH/../../tools/validateDeclarationFile.js $MODULE_PATH/cleaned/index.d.ts)" >> $LOG_FILE_CLEANED
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done
