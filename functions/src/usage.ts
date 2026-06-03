import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const resetDailyUsage = functions.pubsub
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
