"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.verifyAuth = verifyAuth;
const functions = require("firebase-functions");
function verifyAuth(context) {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "You must be logged in to use this feature.");
    }
}
//# sourceMappingURL=auth_check.js.map