/*
 * Copyright Accedia 2015
 */
var express = require("express");
var parser = require("body-parser");
var userController = require("Controllers/usercontroller.js");
var serverContext = require("./models/serverContext");

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

	serverContext().then(function(models){
		
	}, function(error) {
		
	});
    request.end(returnData);
});

app.post('/api/register', function (request, response) {
    var username = request.body.username;
    var password = request.body.password;
    var token = request.body.token;
    var displayName = request.body.displayname;

    var returnData = userController.RegisterUser(username, password, token, displayName);

    request.end(returnData);
});

app.listen(8080, function () {
    console.log("Service running...");
});