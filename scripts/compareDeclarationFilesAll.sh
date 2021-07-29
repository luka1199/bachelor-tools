#!/bin/bash

SCRIPT_PATH="$(
    cd "$(dirname "$0")"
    pwd -P
)"

RESULTS_FOLDER="$(pwd)/$1"
DEFINITELY_TYPED_FOLDER="$(pwd)/$2"
OUTPUT_FOLDER="$RESULTS_FOLDER/output"
rm -f "$RESULTS_FOLDER/compare/comparison.csv"
mkdir -p "$RESULTS_FOLDER/compare"
rm -rf "$RESULTS_FOLDER/compare/differences"
mkdir "$RESULTS_FOLDER/compare/differences"
echo '"ModuleName", "Template", "template-is-different", "type-solvable-difference", "type-unsolvable-difference", "extra-parameter", "missing-parameter", function-missing", "function-extra", "function-overloading-difference, "export-assignment-is-different"' \
    > "$RESULTS_FOLDER/compare/comparison.csv"

N=4
for MODULE in $(cat $RESULTS_FOLDER/modulesWithDeclarationFile.csv); do
    (
        echo ">> $MODULE"
        echo "  > Generating CSV..."
        docker run --rm -v $DEFINITELY_TYPED_FOLDER/types/$MODULE/index.d.ts:/usr/local/app/expected.d.ts -v $OUTPUT_FOLDER/$MODULE/cleaned/index.d.ts:/usr/local/app/actual.d.ts \
            dts-compare --expected-declaration-file expected.d.ts \
                --actual-declaration-file actual.d.ts \
                --output-format "csv" >> "$RESULTS_FOLDER/compare/comparison.csv" \
                --module-name $MODULE

        echo "  > Generating JSON..."
        mkdir -p "$RESULTS_FOLDER/compare/differences"
        docker run --rm -v $DEFINITELY_TYPED_FOLDER/types/$MODULE/index.d.ts:/usr/local/app/expected.d.ts -v $OUTPUT_FOLDER/$MODULE/cleaned/index.d.ts:/usr/local/app/actual.d.ts \
            dts-compare --expected-declaration-file expected.d.ts \
                --actual-declaration-file actual.d.ts \
                --output-format "json" > "$RESULTS_FOLDER/compare/differences/$MODULE.json" \
                --module-name $MODULE
    ) &

    # allow to execute up to $N jobs in parallel
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done