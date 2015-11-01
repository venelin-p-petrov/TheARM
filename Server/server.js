/*
 * Copyright Accedia 2015
 */
var express = require("express");
var app = express();
var constantsModule = require("./constants");
var orm = require("orm");
var userModule = require("./models/user");
var serverContext = require("./models/serverContext");

serverContext()
    .then(function (models) {

    }, function (error) {
        console.log("Error: " + JSON.stringify(error));
});

app.get("/", function (request, response) {
    response.write("" + JSON.stringify(constantsModule.mySqlUrl()));
    response.end();
});

app.listen(8080, function () {
    // code here
});