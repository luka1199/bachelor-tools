#!/bin/bash

SCRIPT_PATH="$(
    cd "$(dirname "$0")"
    pwd -P
)"

TEST_SCRIPTS_DEFINITELY_TYPED=$1
TEST_SCRIPTS_TOP_1000=$2
OUTPUT_FOLDER=$3

node $SCRIPT_PATH/../../tools/getTestScriptData.js \
    $TEST_SCRIPTS_DEFINITELY_TYPED \
    $OUTPUT_FOLDER/testScriptData_definitelyTyped.json \
    $OUTPUT_FOLDER/modulesWithTestScript_definitelyTyped.csv \
    $OUTPUT_FOLDER/keywords_definitelyTyped.json

node $SCRIPT_PATH/../../tools/getTestScriptData.js \
    $TEST_SCRIPTS_TOP_1000 \
    $OUTPUT_FOLDER/testScriptData_top1000.json \
    $OUTPUT_FOLDER/modulesWithTestScript_top1000.csv \
    $OUTPUT_FOLDER/keywords_top1000.json
