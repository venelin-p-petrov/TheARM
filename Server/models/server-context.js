/*
 * Used to get models from the db
*/
var orm = require("orm");
var Q = require("Q");
var constants = require("../constants");

// include models
var user = require("./user");
var resource = require("./resource");
var event = require("./event");
var rule = require("./rule");
var company = require("./company");

module.exports = function () {
    var deferred = Q.defer();

    orm.connect(constants.mySqlUrl(), function (err, db) {
        if (err) {
            deferred.reject(err);
        }

        // define tables
        var User = db.define("user", user);
        var Resource = db.define("resource", resource);
        var Event = db.define("event", event);
        var Rule = db.define("rule", rule);
        var Company = db.define("company", company);

        // define relationships
        Event.hasOne("resource", Resource, { reverse: "events" });
        Resource.hasOne("company", Company, { reverse: "resources" });
        User.hasMany("events", Event, {}, { reverse: "users", key: true });
        User.hasMany("companies", Company, {}, { reverse: "users" });
        Rule.hasMany("resources", Resource, {}, { reverse: "rules", key: true });

        db.sync(function (err) {
            if (err) {
                deferred.reject(err);
            }
        });

        deferred.resolve(db.models);
    });

    return deferred.promise;
};

