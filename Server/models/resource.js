/*
 * Resource model
*/
module.exports = {
    resourceId: { type: "serial", required: "true", key: true },
    image: { type: "text", required: "true" },
    name: { type: "text", required: "true" },
};