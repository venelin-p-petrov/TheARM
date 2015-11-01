/*
 * User model
*/
module.exports = {
    userId: { type: "serial", required: "true", key: true },
    email: { type: "text", required: "true", unique: true },
    password: { type: "text", required: "true" },
    os: { type: "text", required: "true" },
    displayName: { type: "text", required: "true", unique: true },
    token: { type: "text", required: "true" },
};
