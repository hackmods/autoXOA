//modules
const express = require('express');
const assert = require('assert');
const bodyParser = require("body-parser");
const fs = require('fs');

const app = express();
app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json());
app.use(express.static(__dirname + '/public'));
const urlencodedParser = bodyParser.urlencoded({ extended: false });

if (app.get('env') == 'development') {
    app.locals.pretty = true;
}

//routes
app.get('/', function (req, res) {

    try {  
        var data = fs.readFileSync('../autoinstall/AutoXOA.sh', 'utf8');
        console.log('loaded: ' + data);
        res.status(200).send(data);    
    } catch(e) {
        console.log('Error:', e.stack);
        res.status(500).send(`Read error`);    
    }
    
});

app.listen(8080, function () {
    console.log(`Express is now serving web pages`);
});
