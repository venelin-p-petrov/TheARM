/*
 * Copyright Accedia 2015
 */
var express = require("express");
var parser = require("body-parser");

var userController = require("Controllers/users-controller.js");
var companiesController = require("Controllers/companies-controller.js");
var eventsController = require("Controllers/events-controller.js");
var resourcesController = require("Controllers/resources-controller.js");
var constants = require("./constants");

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

    var userControllerInstance = userController.loginUser(username, password, token);

    userControllerInstance.then(function (loginResult) {
        response.end(loginResult);
    });
});

app.post('/api/register', function (request, response) {
    var username = request.body.username;
    var password = request.body.password;
    var token = request.body.token;
    var email = request.body.email;
    var os = request.body.os;

    console.log("Registration attempt from user " + username);

    var userControllerInstance = userController.registerUser(username, password, token, email, os);

    userControllerInstance.then(function (registerData) {
        response.end(registerData);
    });
});

app.get('/api/ping', function (request, response)
{
    response.end("Alive");
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

app.post('/api/:companyId/events/create', function (request, response) {
    var newEvent = request.body.event;
    var ownerId = request.body.ownerId;
	var companyId = request.params.companyId;
	console.log("--- in POST/api/:companyId/events/create - " + companyId + ", " + JSON.stringify(newEvent));
    
    eventsController.createEvent(newEvent, ownerId)
        .then(function (event) {
            response.end(JSON.stringify(event));
        }, function (error) {
            response.end(JSON.stringify(new Error("Error creating event", error)));
    });
});

app.get('/api/:companyId/events', function (request, response)
{
    var companyId = request.params.companyId;
    console.log("--- in GET/api/:companyId/events - " + companyId);

    companiesController.getEventsByCompany(companyId)
        .then(function (resources) {
            response.end(JSON.stringify(resources));
        }, function (error) {
            response.end(JSON.stringify(new Error("Error getting events for company", error)));
        });
});

app.get('/api/:companyId/events/:eventid', function (request, response)
{
    var companyId = request.params.companyId;
    var eventId = request.params.eventid;
    console.log("--- in GET/api/:companyId/events/:eventid - " + companyId + ", " + eventId);

    companiesController.getEventDataByCompany(companyId, eventId)
        .then(function (resources) {
            response.end(JSON.stringify(resources));
        }, function (error) {
            response.end(JSON.stringify(new Error("Error getting event data for company", error)));
        });
});

app.post('/api/:companyId/events/join', function (request, response)
{
    var username = request.body.username;
    var eventId = request.body.eventId;
    console.log("--- in POST/api/:companyId/events/join " + username + ", " + eventId);

    eventsController.joinEvent(username, eventId)
        .then(function () {
            response.end("ok");
        }, function (error) {
            response.end(JSON.stringify(new Error("Error joining event", error)));
        });
});

app.post('/api/:companyId/events/leave', function (request, response)
{
    var username = request.body.username;
    var eventId = request.body.eventId;
    console.log("--- in POST/api/:companyId/events/leave " + username + ", " + eventId);

    eventsController.leaveEvent(username, eventId)
        .then(function () {
            response.end("ok");
        }, function (error) {
            response.end(JSON.stringify(new Error("Error leaving event", error)));
        });
});

app.delete('/api/:companyId/events/delete/:eventid/:userid', function (request, response)
{
    var userId = request.params.userid;
    var eventId = request.params.eventid;
    console.log("--- in DELETE/api/:companyId/events/delete/:eventid/:userid " + userId + ", " + eventId);

    eventsController.deleteEvent(eventId)
        .then(function () {
            response.end("ok");
        }, function (error) {
            response.end(JSON.stringify(new Error("Error deleting event", error)));
        });
});

app.get('/api/images/:imageId', function (request, response) {
    var imageId = request.params.imageId;
    console.log("--- in GET/images/:imageName " + imageId);
    
    var options = {
        root: "./" + constants.imagesFolder + "/"
    };
    response.sendFile(imageId, options);
});

app.listen(8080, function () {
    console.log("Service running...");
});
