const fs = require('fs');
const path = require('path');
const pkgJson = require('./package.json');
const filename = path.resolve(__dirname, './dist/package.json');

fs.writeFile(filename, JSON.stringify(pkgJson, null, 2), function (err) {
    if (err) {
        console.log(err);
        return;
    }
    console.log('write package.json success');
    console.log(filename);
    console.log(pkgJson.version);
});