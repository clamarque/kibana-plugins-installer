const fs = require('fs');
const path = require('path');
const exec = require('child_process').exec;

const timestamp = new Date();
const directoryPath = '$KIBANA_HOME';
const cmdRemove = '$KIBANA_HOME/bin/kibana-plugin.bat remove ';
const cmdInstall = '$KIBANA_HOME/bin/kibana-plugin.bat install ';

fs.readdir(directoryPath + '/plugins', (err, files) => {
    files.forEach(file => {
        // indexOf('.')+1 permet d'enlever le point initial
        let ext = file.substring(file.indexOf('.'))
        let filename = path.basename(file, ext)
        console.log(file);

        if (ext === '.tmp.zip') {
            fs.createReadStream(directoryPath + '/plugins/' + file).pipe(fs.createWriteStream(directoryPath + '/plugins_backup/' + filename + '-' + timestamp.toISOString().substring(0, 10) + '.zip'))
            fs.rename(directoryPath + '/plugins/' + file, directoryPath + '/plugins/' + filename + '.zip', function (err) {
                if (err) throw err
                console.log('The file has been renamed')
            })
            let logStream = fs.createWriteStream(directoryPath + '/logs/' + filename + '.log', { flags: 'a' })
            exec(cmdRemove + filename, function (sterr, stdout) {
                if (sterr !== null) logStream.write(timestamp + ': ' + sterr)
                logStream.write(timestamp + ': ' + 'Removing the plugin before install \n')
                logStream.write(timestamp + ': ' + stdout)
            })
            exec(cmdInstall + 'file://' + directoryPath + '/plugins/' + filename + '.zip', function (sterr, stdout) {
                if (sterr !== null) logStream.write(timestamp + ': ' + sterr)
                logStream.write(timestamp + ': ' + 'Installation of the plugin Kibana ' + filename + '\n')
                logStream.write(timestamp + ': ' + stdout)
            })
        }  else {
            console.log('Unknown extension')
        }
    })
})
