/* 
 *  Contains app settings
*/
module.exports = {
    baseUrl: "localhost",
    mySql: "mysql://",
    username: "root",
    password: "",
    database: "thearmdb",
    dbPort: "3306",
    mySqlUrl: function () {
        return this.mySql + this.username + ":" + this.password + "@" + this.baseUrl + ":" + this.dbPort + "/" + this.database;
    },
    imagesFolder: "images"
};