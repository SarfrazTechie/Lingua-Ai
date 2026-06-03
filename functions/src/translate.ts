import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { verifyAuth } from "./middleware/auth_check";
import { checkLimit } from "./middleware/limit_check";

export const translateText = functions.https.onCall(async (data, context) => {
  verifyAuth(context);

  const { text, sourceLang, targetLang, tone = "neutral" } = data;

  if (!text || !sourceLang || !targetLang) {
    throw new functions.https.HttpsError("invalid-argument", "Missing required fields");
  }
  if (text.length > 500) {
    throw new functions.https.HttpsError("invalid-argument", "Text too long. Max 500 characters.");
  }

  const uid = context.auth!.uid;
  await checkLimit(uid);

  try {
    const Groq = (await import("groq-sdk")).default;
    const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

    const prompt = `Translate the following text from ${sourceLang} to ${targetLang}.
Tone: ${tone}
Text: "${text}"
Return only the translated text, nothing else.`;

    const response = await groq.chat.completions.create({
      model: "llama3-8b-8192",
      messages: [{ role: "user", content: prompt }],
      max_tokens: 500,
      temperature: 0.3,
    });

    const translation = response.choices[0]?.message?.content?.trim() || "";
    const tokens = response.usage?.total_tokens || 0;

    const today = new Date().toISOString().split("T")[0];
    const ref = admin.firestore().doc(`usage/${uid}/daily/${today}`);
    await ref.set(
      {
        messageCount: admin.firestore.FieldValue.increment(1),
        tokenCount: admin.firestore.FieldValue.increment(tokens),
        lastUpdated: new Date().toISOString(),
      },
      { merge: true }
    );

    return { translation, tokens };
  } catch (error) {
    throw new functions.https.HttpsError("internal", "Translation failed");
  }
});
