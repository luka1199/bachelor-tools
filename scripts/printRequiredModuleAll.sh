#!/bin/bash
SCRIPT_PATH="$(
    cd "$(dirname "$0")"
    pwd -P
)"

OUTPUT_FOLDER="$1"

N=4
for MODULE_PATH in $OUTPUT_FOLDER/*; do
    (
        MODULE=$(basename $MODULE_PATH)
        node $SCRIPT_PATH/../../tools/printRequiredModule.js $MODULE $MODULE_PATH/cleaned/output.json
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done
