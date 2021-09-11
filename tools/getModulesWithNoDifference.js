const fs = require('fs')

var lines = fs.readFileSync(process.argv[2]).toString().split('\n')
const isEqualToZero = (currentValue) => currentValue == '0';

var modulesWithNoDifference = []
lines.forEach(line => {
    var entries = line.split(',')
    if (entries.slice(2).every(isEqualToZero)) {
        if (line == '') return
        modulesWithNoDifference.push(entries[0])
    }
});

console.log(modulesWithNoDifference.length);
console.log(modulesWithNoDifference);