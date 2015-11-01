/*
 * Event model
*/
module.exports = {
    ruleId: { type: "serial", required: "true", key: true },
    key: { type: "text", required: "true" },
    value: { type: "text", required: "true" },
    operator: { type: "text", required: "true" },
    type: { type: "text", required: "true" }
};