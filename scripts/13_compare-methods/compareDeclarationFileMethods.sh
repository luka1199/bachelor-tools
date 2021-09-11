#!/bin/bash

SCRIPT_PATH="$(
    cd "$(dirname "$0")"
    pwd -P
)"

COMPARISON_README=$1
COMPARISON_TEST=$2
OUTPUT_FOLDER=$3

node $SCRIPT_PATH/../../tools/compareDeclarationFileMethods.js $COMPARISON_README $COMPARISON_TEST $OUTPUT_FOLDER