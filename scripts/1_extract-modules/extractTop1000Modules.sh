#!/bin/bash

SCRIPT_PATH="$(
    cd "$(dirname "$0")"
    pwd -P
)"

OUTPUT_FILE=$1

echo "Extracting modules ..."
node $SCRIPT_PATH/../../tools/getTop1000Modules.js > $OUTPUT_FILE

echo "Done"
echo ""
echo "Path to file:"
echo $OUTPUT_FILE
