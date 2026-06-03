"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkLimit = checkLimit;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const DAILY_LIMITS = {
    guest: 5,
    free: 20,
    premium: 500,
};
async function checkLimit(uid) {
    var _a, _b, _c, _d, _e, _f;
    const today = new Date().toISOString().split("T")[0];
    const userDoc = await admin.firestore().doc(`users/${uid}`).get();
    const isPremium = (_b = (_a = userDoc.data()) === null || _a === void 0 ? void 0 : _a.isPremium) !== null && _b !== void 0 ? _b : false;
    const isGuest = (_d = (_c = userDoc.data()) === null || _c === void 0 ? void 0 : _c.isGuest) !== null && _d !== void 0 ? _d : false;
    const plan = isPremium ? "premium" : isGuest ? "guest" : "free";
    const limit = DAILY_LIMITS[plan];
    const usageDoc = await admin
        .firestore()
        .doc(`usage/${uid}/daily/${today}`)
        .get();
    const currentCount = (_f = (_e = usageDoc.data()) === null || _e === void 0 ? void 0 : _e.messageCount) !== null && _f !== void 0 ? _f : 0;
    if (currentCount >= limit) {
        throw new functions.https.HttpsError("resource-exhausted", `Daily limit of ${limit} messages reached.`);
    }
}
//# sourceMappingURL=limit_check.js.map