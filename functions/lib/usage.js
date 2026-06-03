"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.resetDailyUsage = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
exports.resetDailyUsage = functions.pubsub
    .schedule("0 0 * * *")
    .timeZone("UTC")
    .onRun(async () => {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const dateStr = yesterday.toISOString().split("T")[0];
    const usersSnapshot = await admin.firestore().collection("users").get();
    const batch = admin.firestore().batch();
    usersSnapshot.forEach((doc) => {
        const ref = admin
            .firestore()
            .doc(`usage/${doc.id}/daily/${dateStr}`);
        batch.delete(ref);
    });
    await batch.commit();
    console.log(`Cleared usage for ${dateStr}`);
});
//# sourceMappingURL=usage.js.map