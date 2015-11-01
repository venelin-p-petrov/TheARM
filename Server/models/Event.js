/*
 * Event model
*/
module.exports = {
    eventId: { type: "serial", required: "true", key: true },
    description: { type: "text", required: "true" },
    minUsers: { type: "integer", required: "true" },
    maxUsers: { type: "integer", required: "true" },
    startTime: { type: "date", required: "true" },
    endTime: { type: "date", required: "true" }
};