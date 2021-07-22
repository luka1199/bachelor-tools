const fs = require('fs')
const path = require('path')

if (!process.argv[2]) {
    console.log("No analysis path specified.")
    process.exit()
}

const analysisPath = process.argv[2]

if (!fs.existsSync(analysisPath)) {
    console.log('ERROR');
    process.exit()
}
var analysis = fs.readFileSync(analysisPath).toString()

try {
    if (analysis != "") {
        JSON.parse(analysis)
    } else {
        console.log('EMPTY');
        process.exit()
    }
} catch (error) {
    console.log('INVALID');
    process.exit()
    // console.log(error);
}
console.log('OK');