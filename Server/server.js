/*
 * Copyright Accedia 2015
 */
var express = require("express");
var parser = require("body-parser");
var userController = require("Controllers/users-controller.js");
var companiesController = require("Controllers/companies-controller.js");
var eventsController = require("Controllers/events-controller.js");
var resourcesController = require("Controllers/resources-controller.js");

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

    console.log("Login atempt from user: " + username);

    userController.loginUser(username, password, token, function (loginResult)
    {
        response.end(loginResult);
    });
});

app.post('/api/register', function (request, response) {
    var username = request.body.username;
    var password = request.body.password;
    var token = request.body.token;
    var displayName = request.body.displayname;
    var email = request.body.email;
    var os = request.body.os;

    console.log("Registration attempt from user " + username);

    var returnData = userController.registerUser(username, password, token, displayName, email, os, function (registerData)
    {
        response.end(registerData);
    });
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