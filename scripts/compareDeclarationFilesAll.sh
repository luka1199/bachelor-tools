#!/bin/bash

SCRIPT_PATH="$(
    cd "$(dirname "$0")"
    pwd -P
)"

OUTPUT_FOLDER="$(pwd)/$1"
OUTPUT_FOLDER_COMPARE="$(pwd)/$2"
LOG_FILE_NORMAL="$OUTPUT_FOLDER/../compare_declaration_files_normal.log"
LOG_FILE_CLEANED="$OUTPUT_FOLDER/../compare_declaration_files_cleaned.log"
rm -f $LOG_FILE_NORMAL
rm -f $LOG_FILE_CLEANED
touch $LOG_FILE_NORMAL
touch $LOG_FILE_CLEANED

N=4
for MODULE_PATH in $OUTPUT_FOLDER/*; do
    # (
        MODULE=$(basename $MODULE_PATH)
        echo ">> $MODULE"
        docker run --rm -v $OUTPUT_FOLDER_COMPARE/$MODULE/myfunction.expected.d.ts:/usr/local/app/expected.d.ts -v $(pwd)/examples/module-function/myfunction.actual.d.ts:/usr/local/app/actual.d.ts dts-compare --expected-declaration-file expected.d.ts --actual-declaration-file actual.d.ts
        # echo "$MODULE - $(node $SCRIPT_PATH/../tools/validateDeclarationFile.js $MODULE_PATH/normal/index.d.ts)" >> $LOG_FILE_NORMAL
        # echo "$MODULE - $(node $SCRIPT_PATH/../tools/validateDeclarationFile.js $MODULE_PATH/cleaned/index.d.ts)" >> $LOG_FILE_CLEANED
    # ) &

    # # allow to execute up to $N jobs in parallel
    # if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
    #     wait -n
    # fi
done

docker run --rm -v $(pwd)/examples/module-function/myfunction.expected.d.ts:/usr/local/app/expected.d.ts -v $(pwd)/examples/module-function/myfunction.actual.d.ts:/usr/local/app/actual.d.ts dts-compare --expected-declaration-file expected.d.ts --actual-declaration-file actual.d.ts