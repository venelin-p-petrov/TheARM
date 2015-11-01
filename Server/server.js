/*
 * Copyright Accedia 2015
 */
var express = require("express");
var parser = require("body-parser");
var serverContext = require("./models/serverContext");
var userController = require("Controllers/usercontroller.js");
var companiesController = require("Controllers/companiescontroller.js");
var eventsController = require("Controllers/eventcontroller.js");
var resourcesController = require("Controllers/resourcecontroller.js");

serverContext()
    .then(function (models) {
        console.log("Created db!");
        models.user.create([{
                userId: 0,
                email: "user",
                password: "test",
                os: "os",
                displayName: "d",
                token: "sda",
        }, {
            userId: 0,
            email: "user",
            password: "test",
            os: "os",
            displayName: "d",
            token: "sda",
        }], function (err, items) {
            console.log("error: " + err);
        });
    }, function (err) {
        console.log("Error: " + err);
    });

var app = express();

app.use(parser.urlencoded(
{
    extended : true
}));
app.use(parser.json());

app.post('/api/login', function (request, response)
{
    var username = request.body.username;
    var password = request.body.password;
    var token = request.body.token;

    var returnData = userController.LoginUser(username, password, token);

    response.end(returnData);
});

app.post('/api/register', function (request, response) {
    var username = request.body.username;
    var password = request.body.password;
    var token = request.body.token;
    var displayName = request.body.displayname;

    var returnData = userController.RegisterUser(username, password, token, displayName);

    response.end(returnData);
});

app.get('/api/companies', function (request, response)
{
    response.end();
});

app.get('/api/:companyName/resources', function (request, response)
{

});

app.get('/api/:companyName/resources/:resourceId', function (request, response)
{

});

app.get('/api/:companyName/events', function (request, response)
{

});

app.get('/api/:companyName/events/:eventid', function (request, response)
{

});

app.post('/api/:companyName/events', function (request, response)
{

});

app.post('/api/:companyName/events/join', function (request, response)
{

});

app.post('/api/:companyName/events/leave', function (request, response)
{

});

app.delete('/api/:companyName/events/delete/:eventid/:userid', function (request, response)
{

});

app.listen(8080, function () {
    console.log("Service running...");
});