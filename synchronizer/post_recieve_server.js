var express = require('express'),
    exec = require('child_process').exec,
    port = 1232,
    child;

var app = express.createServer(
    express.bodyParser()
);
app.post('/github/postreceive', function(req, res) {
    var body = JSON.parse(req.body.payload);
    child = exec('ls',
                 function (error, stdout, stderr) {
                     console.log('stdout: ' + stdout);
                     console.log('stderr: ' + stderr);
                     if (error !== null) {
                         console.log('exec error: ' + error);
                     }
                 });
    // console.log(body.repository.name);
});

app.listen(port);
