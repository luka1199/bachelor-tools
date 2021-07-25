const fs = require('fs')
const path = require('path')

if (!process.argv[2]) {
    console.log("No declaration file path specified.")
    process.exit()
}

const declarationFilePath = process.argv[2]

if (!fs.existsSync(declarationFilePath)) {
    console.log('NOK');
    process.exit()
}
var declarationFile = fs.readFileSync(declarationFilePath).toString()

if (declarationFile != "") {
    console.log('OK');
} else {
    console.log('EMPTY');
    process.exit()
}