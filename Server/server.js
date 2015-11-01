/*
 * Copyright Accedia 2015
 */
var express = require("express");
var parser = require("body-parser");
var Error = require("./models/error");
var userController = require("Controllers/users_controller.js");
var companiesController = require("Controllers/companies_controller.js");
var eventsController = require("Controllers/events_controller.js");
var resourcesController = require("Controllers/resources_controller.js");

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

    var returnData = userController.registerUser(username, password, token, displayName);

    response.end(returnData);
});

app.get('/api/companies', function (request, response)
{
    console.log("--- in GET/api/companies");

    companiesController.getAll()
        .then(function (companies) {
            response.end(JSON.stringify(companies));
        }, function (error) {
            response.end(JSON.stringify(new Error("Error getting companies", error)));
        });
});

app.get('/api/:companyId/resources', function (request, response)
{
    var companyId = request.params.companyId;
    console.log("--- in GET/api/:companyId/resources - " + companyId);

    companiesController.getResourcesByCompany(companyId)
        .then(function (resources) {
            response.end(JSON.stringify(resources));
        }, function (error) {
            response.end(JSON.stringify(new Error("Error getting company resources", error)));
        });
});

app.get('/api/:companyId/resources/:resourceId', function (request, response)
{
    var companyId = request.params.companyId;
    var resourceId = request.params.resourceId;
    console.log("--- in GET/api/:companyId/resources/:resourceId - " + companyId + ", " + resourceId);

    companiesController.getResourceDataByCompany(companyId, resourceId)
        .then(function (resources) {
            response.end(JSON.stringify(resources));
        }, function (error) {
            response.end(JSON.stringify(new Error("Error getting resource data for company", error)));
        });
});

app.get('/api/:companyId/events', function (request, response)
{

});

app.get('/api/:companyId/events/:eventid', function (request, response)
{

});

app.post('/api/:companyId/events', function (request, response)
{

});

app.post('/api/:companyId/events/join', function (request, response)
{

});

app.post('/api/:companyId/events/leave', function (request, response)
{

});

app.delete('/api/:companyId/events/delete/:eventid/:userid', function (request, response)
{

});

app.listen(8080, function () {
    console.log("Service running...");
});