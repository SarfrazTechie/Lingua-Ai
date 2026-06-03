import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const DAILY_LIMITS: Record<string, number> = {
  guest: 5,
  free: 20,
  premium: 500,
};

export async function checkLimit(uid: string): Promise<void> {
  const today = new Date().toISOString().split("T")[0];

  const userDoc = await admin.firestore().doc(`users/${uid}`).get();
  const isPremium = userDoc.data()?.isPremium ?? false;
  const isGuest = userDoc.data()?.isGuest ?? false;

  const plan = isPremium ? "premium" : isGuest ? "guest" : "free";
  const limit = DAILY_LIMITS[plan];

  const usageDoc = await admin
    .firestore()
    .doc(`usage/${uid}/daily/${today}`)
    .get();

  const currentCount = usageDoc.data()?.messageCount ?? 0;

  if (currentCount >= limit) {
    throw new functions.https.HttpsError(
      "resource-exhausted",
      `Daily limit of ${limit} messages reached.`
    );
  }
}
