var express = require('express'),
    exec = require('child_process').exec,
    port = 1232,
    command = './doc_builder.sh',
    child;

var app = express.createServer(
    express.bodyParser()
);
app.post('/github/postreceive', function(req, res) {
    var body = JSON.parse(req.body.payload);
    if (body.repository.name === 'Japanese-Translation-of-Google-JavaScript-Style-Guide') {
        child = exec(command,
                     function (error, stdout, stderr) {
                         console.log('stdout: ' + stdout);
                         console.log('stderr: ' + stderr);
                         if (error !== null) {
                             console.log('exec error: ' + error);
                         }
                     });
    }
});

app.listen(port);
