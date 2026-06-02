import * as functions from "firebase-functions";
import { verifyAuth } from "./middleware/auth_check";

export const checkUsage = functions.https.onCall(async (data, context) => {
  verifyAuth(context);

  const uid = context.auth!.uid;
  const admin = await import("firebase-admin");
  const today = new Date().toISOString().split("T")[0];

  const doc = await admin.default
    .firestore()
    .doc(`usage/${uid}/daily/${today}`)
    .get();

  const usage = doc.data() || { messageCount: 0, tokenCount: 0 };

  return usage;
});

export const incrementUsage = functions.https.onCall(async (data, context) => {
  verifyAuth(context);

  const uid = context.auth!.uid;
  const { tokens = 0 } = data;
  const admin = await import("firebase-admin");
  const today = new Date().toISOString().split("T")[0];

  await admin.default
    .firestore()
    .doc(`usage/${uid}/daily/${today}`)
    .set(
      {
        messageCount: admin.default.firestore.FieldValue.increment(1),
        tokenCount: admin.default.firestore.FieldValue.increment(tokens),
        lastUpdated: new Date().toISOString(),
      },
      { merge: true }
    );

  return { success: true };
});

// Reset daily usage at midnight UTC
export const resetDailyUsage = functions.pubsub
  .schedule("0 0 * * *")
  .timeZone("UTC")
  .onRun(async () => {
    console.log("Daily usage reset triggered");
    return null;
  });
