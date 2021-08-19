#!/bin/bash
CURRENT_FOLDER=$(pwd)
OUTPUT_FOLDER="$1"
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_PATH=$SCRIPT_PATH/../..

cd "$OUTPUT_FOLDER"
N=4
for MODULE in $(ls $OUTPUT_FOLDER); do
    (
        echo $MODULE
        mkdir $OUTPUT_FOLDER/$MODULE/normal
        mkdir $OUTPUT_FOLDER/$MODULE/cleaned
        mv $OUTPUT_FOLDER/$MODULE/output.json $OUTPUT_FOLDER/$MODULE/normal
        mv $OUTPUT_FOLDER/$MODULE/output2.json $OUTPUT_FOLDER/$MODULE/cleaned/output.json
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done
cd "$CURRENT_FOLDER"