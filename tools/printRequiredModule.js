const fs = require('fs')
const path = require('path')

if (!process.argv[2]) {
    console.log("No module name specified.")
    process.exit()
}
if (!process.argv[3]) {
    console.log("No analysis path specified.")
    process.exit()
}

const moduleName = process.argv[2]
const analysisPath = process.argv[3]

if (!fs.existsSync(analysisPath)) {
    console.log("No analysis file found.");
    process.exit()
}
var analysis = fs.readFileSync(analysisPath).toString()
var regex = /\"requiredModule\": \"\..*\"/g
var matches = analysis.match(regex)

if (matches != null) {
    matches.forEach(match => {
        console.log(match.split(': ')[1]);
    });
}

