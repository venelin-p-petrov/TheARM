/*
 * Company model
*/
module.exports = {
    companyId: { type: "serial",  required: "true", key: true },
    name: { type: "text", required: "true" }
};