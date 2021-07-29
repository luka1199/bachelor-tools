const fs = require('fs')

if (process.argv[2] == null) {
    console.log("No log file path specified.")
    process.exit()
}

if (process.argv[3] == null) {
    console.log("No log code specified.")
    process.exit()
}

var logFile = fs.readFileSync(process.argv[2]).toString()
var logCode = process.argv[3]

var logList = logFile.split('\n')
logList.forEach(line => {
    if (line == "") return

    var moduleName = line.split(' - ')[0];
    var code = line.split(' - ')[1];
    if (code == logCode) {
        console.log(moduleName);
    }
});