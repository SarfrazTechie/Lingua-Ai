import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { verifyAuth } from "./middleware/auth_check";
import { checkLimit } from "./middleware/limit_check";

export const chatMessage = functions.https.onCall(async (data, context) => {
  verifyAuth(context);

  const { message, history = [], mode = "Travel Companion" } = data;

  if (!message) {
    throw new functions.https.HttpsError("invalid-argument", "Message is required");
  }

  const uid = context.auth!.uid;
  await checkLimit(uid);

  try {
    const Groq = (await import("groq-sdk")).default;
    const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

    const systemPrompt = `You are a helpful AI language assistant specializing in ${mode}.
Help the user with translations, language learning, and cultural context.
Be concise and practical.`;

    const messages = [
      { role: "system" as const, content: systemPrompt },
      ...history.map((h: { role: string; content: string }) => ({
        role: h.role as "user" | "assistant",
        content: h.content,
      })),
      { role: "user" as const, content: message },
    ];

    const response = await groq.chat.completions.create({
      model: "llama3-8b-8192",
      messages,
      max_tokens: 500,
      temperature: 0.7,
    });

    const reply = response.choices[0]?.message?.content?.trim() || "";
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

    return { reply, tokens };
  } catch (error) {
    throw new functions.https.HttpsError("internal", "Chat failed");
  }
});
