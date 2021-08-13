const fs = require('fs')
const path = require('path')

const properties = [
    "templateIsDifferent",
    "typeSolvableDifference",
    "typeUnsolvableDifference",
    "extraParameter",
    "missingParameter",
    "functionMissing",
    "functionExtra",
    "functionOverloadingDifference",
    "exportAssignmentIsDifferent"]

if (!process.argv[2]) {
    console.log("No path to comparison.csv of README method specified.")
    process.exit()
}
if (!process.argv[3]) {
    console.log("No path to comparison.csv of test method specified.")
    process.exit()
}

main()

function main() {
    var comparisonReadmeRaw = fs.readFileSync(process.argv[2]).toString()
    var comparisonTestRaw = fs.readFileSync(process.argv[3]).toString()

    var comparisonReadme = parseComparison(comparisonReadmeRaw)
    var comparisonTest = parseComparison(comparisonTestRaw)

    var commonModules = fs.readFileSync(path.join(__dirname, "..", "data", "commonDeclarationFilesReadmeTest.csv")).toString().split('\n')
    var allModules = [...new Set([...Object.keys(comparisonReadme), ...Object.keys(comparisonTest)])]

    var combinedCommon = getCombinedSummary(comparisonReadme, comparisonTest, commonModules, true)
    var combinedAll = getCombinedSummary(comparisonReadme, comparisonTest, allModules)

    console.log("Common modules:");
    console.table(combinedCommon)
    console.log("All modules:");
    console.table(combinedAll)

    if (process.argv[4]) {
        console.log(`Saving results to ${path.join(process.argv[4], "comparisonCommonModules.json")}...`);
        fs.writeFileSync(path.join(process.argv[4], "comparisonCommonModules.json"), JSON.stringify(combinedCommon, null, 2))
        console.log(`Saving results to ${path.join(process.argv[4], "comparisonAllModules.json")}...`);
        fs.writeFileSync(path.join(process.argv[4], "comparisonAllModules.json"), JSON.stringify(combinedAll, null, 2))
    }
}

function parseComparison(comparisonRaw) {
    comparison = {}

    counter = -1
    comparisonRaw.split('\n').forEach(line => {
        counter++
        if (line == "" || counter == 0) return
        items = line.split(',')
        comparison[items[0]] = {
            template: items[1],
            templateIsDifferent: items[2],
            typeSolvableDifference: items[3],
            typeUnsolvableDifference: items[4],
            extraParameter: items[5],
            missingParameter: items[6],
            functionMissing: items[7],
            functionExtra: items[8],
            functionOverloadingDifference: items[9],
            exportAssignmentIsDifferent: items[10]
        }
    });

    return comparison
}

function getCombinedSummary(comparisonReadme, comparisonTest, moduleList, onlyCommonModules = false) {
    var categoryDataReadme = getCategoryDataTemplate()
    var categoryDataTest = getCategoryDataTemplate()
    var combinedSummary = getSummaryTemplate()

    var keys = Object.keys(getCategoryDataTemplate())

    var values = {
        templateIsDifferent: [],
        typeSolvableDifference: [],
        typeUnsolvableDifference: [],
        extraParameter: [],
        missingParameter: [],
        functionMissing: [],
        functionExtra: [],
        functionOverloadingDifference: [],
        exportAssignmentIsDifferent: []
    }
    var valuesReadme = JSON.parse(JSON.stringify(values))
    var valuesTest = JSON.parse(JSON.stringify(values))
    
    var comparisonCounter = {
        templateIsDifferent: {},
        typeSolvableDifference: {},
        typeUnsolvableDifference: {},
        extraParameter: {},
        missingParameter: {},
        functionMissing: {},
        functionExtra: {},
        functionOverloadingDifference: {},
        exportAssignmentIsDifferent: {}
    }

    moduleList.forEach(module => {
        if (module == "") return
        if (onlyCommonModules && (comparisonReadme[module] == null || comparisonTest[module] == null)) return
        // Readme method
        if (comparisonReadme[module] != null) {
            keys.forEach(key => {
                if (key == "template") return
                var value = parseInt(comparisonReadme[module][key])
                if (Number.isNaN(value)) return
                categoryDataReadme[key].total += value
                categoryDataReadme[key].count++
                categoryDataReadme[key].average = categoryDataReadme[key].total / categoryDataReadme[key].count
                valuesReadme[key].push(value)
            });
        }
        // Test method
        if (comparisonTest[module] != null) {
            keys.forEach(key => {
                if (key == "template") return
                var value = parseInt(comparisonTest[module][key])
                if (key == "typeUnsolvableDifference" && value == 23) console.log(module);
                if (Number.isNaN(value)) return
                categoryDataTest[key].total += value
                categoryDataTest[key].count++
                categoryDataTest[key].average = categoryDataTest[key].total / categoryDataTest[key].count
                valuesTest[key].push(value)
            });
        }
    });

    if (onlyCommonModules) {
        Object.keys(comparisonCounter).forEach(key => {
            comparisonCounter[key]= {equal: 0, readmeMore: 0, testMore: 0}
            for (let i = 0; i < valuesReadme[key].length; i++) {
                const readmeValue = valuesReadme[key][i];
                const testValue = valuesTest[key][i];
                if (readmeValue == testValue) {
                    comparisonCounter[key].equal++
                } else if (readmeValue > testValue) {
                    comparisonCounter[key].readmeMore++
                } else if (readmeValue < testValue) {
                    comparisonCounter[key].testMore++
                }
            }
        });
        printPlotValues(valuesReadme, valuesTest, 'typeSolvableDifference')
        printPlotValues(valuesReadme, valuesTest, 'typeUnsolvableDifference')
    }

    keys.forEach(key => {
        // Calculate category data for README and test
        categoryDataReadme[key].median = median(valuesReadme[key])
        categoryDataTest[key].median = median(valuesTest[key])
        categoryDataReadme[key].min = Math.min(...valuesReadme[key])
        categoryDataReadme[key].max = Math.max(...valuesReadme[key])
        categoryDataTest[key].min = Math.min(...valuesTest[key])
        categoryDataTest[key].max = Math.max(...valuesTest[key])

        // Average, Median, Min, Max README
        var average = Math.round(categoryDataReadme[key].average * 1000) / 1000
        combinedSummary[key].readmeAverage = average
        combinedSummary[key].readmeMedian = categoryDataReadme[key].median
        combinedSummary[key].readmeMin = categoryDataReadme[key].min
        combinedSummary[key].readmeMax = categoryDataReadme[key].max

        // Average, Median, Min, Max test
        var average = Math.round(categoryDataTest[key].average * 1000) / 1000
        combinedSummary[key].testAverage = average
        combinedSummary[key].testMedian = categoryDataTest[key].median
        combinedSummary[key].testMin = categoryDataTest[key].min
        combinedSummary[key].testMax = categoryDataTest[key].max

        // Equal, readmeMore, testMore
        combinedSummary[key].equal = comparisonCounter[key].equal
        combinedSummary[key].readmeMore = comparisonCounter[key].readmeMore
        combinedSummary[key].testMore = comparisonCounter[key].testMore
    });

    return combinedSummary
}

function getCategoryDataTemplate() {
    var template = {}
    properties.forEach(prop => {
        template[prop] = {
            total: 0,
            count: 0,
            average: null,
            median: null,
            min: Number.MAX_VALUE,
            max: Number.MIN_VALUE
        }
    });
    return template
}

function getSummaryTemplate() {
    var template = {}
    properties.forEach(prop => {
        template[prop] = {
            readmeAverage: null,
            testAverage: null,
            readmeMedian: null,
            testMedian: null,
            readmeMin: Number.MAX_VALUE,
            testMin: Number.MAX_VALUE,
            readmeMin: Number.MIN_VALUE,
            testMin: Number.MIN_VALUE,
            equal: null,
            readmeMore: null,
            testMore: null
        }
    });
    return template
}

function median(values) {
    values = [...values]
    if (values.length === 0) return 0;

    values.sort(function (a, b) {
        return a - b;
    });

    var half = Math.floor(values.length / 2);

    if (values.length % 2)
        return values[half];

    return (values[half - 1] + values[half]) / 2.0;
}

function printPlotValues(valuesReadme, valuesTest, valueKey) {
    var coordinateCounter = {}
    for (let i = 0; i < valuesReadme[valueKey].length; i++) {
        const value1 = valuesReadme[valueKey][i];
        const value2 = valuesTest[valueKey][i];
        if (coordinateCounter[`${value1},${value2}`] == null) coordinateCounter[`${value1},${value2}`] = 0
        coordinateCounter[`${value1},${value2}`]++
    }
    console.log()
    console.log(`${valueKey}:`);
    Object.keys(coordinateCounter).forEach(key => {
        var values = key.split(',')
        console.log(`${values[0]} ${values[1]} ${coordinateCounter[key]}`);
    });
}