import * as functions from "firebase-functions";

const FREE_DAILY_LIMIT = 20;
const PREMIUM_DAILY_LIMIT = 500;
const GUEST_DAILY_LIMIT = 5;

export async function checkLimit(uid: string): Promise<void> {
  const admin = await import("firebase-admin");
  const today = new Date().toISOString().split("T")[0];

  // Get user subscription status
  const userDoc = await admin.default
    .firestore()
    .doc(`users/${uid}`)
    .get();

  const isPremium = userDoc.data()?.isPremium || false;
  const isGuest = userDoc.data()?.isGuest || false;

  const limit = isPremium
    ? PREMIUM_DAILY_LIMIT
    : isGuest
    ? GUEST_DAILY_LIMIT
    : FREE_DAILY_LIMIT;

  // Get today usage
  const usageDoc = await admin.default
    .firestore()
    .doc(`usage/${uid}/daily/${today}`)
    .get();

  const messageCount = usageDoc.data()?.messageCount || 0;

  if (messageCount >= limit) {
    throw new functions.https.HttpsError(
      "resource-exhausted",
      `Daily limit of ${limit} messages reached. Upgrade to Premium for more.`
    );
  }
}
