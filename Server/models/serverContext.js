/*
 * Used to get models from the db
*/
var orm = require("orm");
var Q = require("Q");
var user = require("./user");
var constants = require("../constants");

module.exports = function () {
    var deferred = Q.defer();

    orm.connect(constants.mySqlUrl(), function (err, db) {
        if (err) {
            deferred.reject(err);
        }

        var Users = db.define("user", user);

        db.sync(function (err) {
            if (err) {
                deferred.reject(err);
            }
        });

        deferred.resolve(db.models);
    });

    return deferred.promise;
};

