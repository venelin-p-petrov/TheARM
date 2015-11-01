/*
 * User model
*/
module.exports = {
    userId: { type: "integer", required: "true", key: true },
    email: { type: "text", required: "true" },
    password: { type: "text", required: "true" },
    os: { type: "text", required: "true" },
    displayName: { type: "text", required: "true" },
    token: { type: "text", required: "true" },
};
