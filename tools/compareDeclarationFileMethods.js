const fs = require('fs')
const path = require('path')
const { mainModule } = require('process')

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
    var commonModules = fs.readFileSync(path.join(__dirname, "..", "data", "commonDeclarationFilesReadmeTest.csv")).toString().split('\n')
    
    var comparisonReadmeRaw = fs.readFileSync(process.argv[2]).toString()
    var comparisonTestRaw = fs.readFileSync(process.argv[3]).toString()
    
    var comparisonReadme = parseComparison(comparisonReadmeRaw)
    var comparisonTest = parseComparison(comparisonTestRaw)

    commonModules.forEach(module => {
        if (module == "") return
        if (comparisonReadme[module] == null && comparisonTest[module] == null) return
        console.log(`${module}:`);
        console.log(comparisonReadme[module]);
        console.log(comparisonTest[module]);
    });
}




function parseComparison(comparisonRaw) {
    comparison = {}

    comparisonRaw.split('\n').forEach(line => {
        if (line == "") return
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