import * as functions from "firebase-functions";
import OpenAI from "openai";
import { verifyAuth } from "./middleware/auth_check";
import { checkLimit } from "./middleware/limit_check";

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export const translateText = functions.https.onCall(async (data, context) => {
  // Verify auth
  verifyAuth(context);

  const { text, sourceLang, targetLang, tone = "neutral" } = data;

  if (!text || !sourceLang || !targetLang) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required fields"
    );
  }

  if (text.length > 500) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Text too long. Max 500 characters."
    );
  }

  // Check daily limit
  const uid = context.auth!.uid;
  await checkLimit(uid);

  try {
    const prompt = `Translate the following text from ${sourceLang} to ${targetLang}.
Tone: ${tone}
Text: "${text}"
Return only the translated text, nothing else.`;

    const response = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: prompt }],
      max_tokens: 500,
      temperature: 0.3,
    });

    const translation = response.choices[0]?.message?.content?.trim() || "";

    // Increment usage
    await incrementUsageCount(uid, response.usage?.total_tokens || 0);

    return { translation, tokens: response.usage?.total_tokens || 0 };
  } catch (error) {
    throw new functions.https.HttpsError("internal", "Translation failed");
  }
});

async function incrementUsageCount(uid: string, tokens: number) {
  const admin = await import("firebase-admin");
  const today = new Date().toISOString().split("T")[0];
  const ref = admin.default
    .firestore()
    .doc(`usage/${uid}/daily/${today}`);

  await ref.set(
    {
      messageCount: admin.default.firestore.FieldValue.increment(1),
      tokenCount: admin.default.firestore.FieldValue.increment(tokens),
      lastUpdated: new Date().toISOString(),
    },
    { merge: true }
  );
}
