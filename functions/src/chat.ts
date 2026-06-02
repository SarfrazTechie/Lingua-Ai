import * as functions from "firebase-functions";
import OpenAI from "openai";
import { verifyAuth } from "./middleware/auth_check";
import { checkLimit } from "./middleware/limit_check";

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export const chatWithAI = functions.https.onCall(async (data, context) => {
  verifyAuth(context);

  const { message, history = [], mode = "General" } = data;

  if (!message) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Message is required"
    );
  }

  const uid = context.auth!.uid;
  await checkLimit(uid);

  try {
    const systemPrompt = `You are LinguaAI, an expert AI language assistant.
Current mode: ${mode}
Be helpful, natural, and conversational.
Keep responses concise and relevant to language learning and translation.`;

    const messages = [
      { role: "system" as const, content: systemPrompt },
      ...history.map((m: any) => ({
        role: m.role as "user" | "assistant",
        content: m.content,
      })),
      { role: "user" as const, content: message },
    ];

    const response = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages,
      max_tokens: 500,
      temperature: 0.7,
    });

    const reply = response.choices[0]?.message?.content?.trim() || "";

    // Increment usage
    const admin = await import("firebase-admin");
    const today = new Date().toISOString().split("T")[0];
    await admin.default
      .firestore()
      .doc(`usage/${uid}/daily/${today}`)
      .set(
        {
          messageCount: admin.default.firestore.FieldValue.increment(1),
          tokenCount: admin.default.firestore.FieldValue.increment(
            response.usage?.total_tokens || 0
          ),
          lastUpdated: new Date().toISOString(),
        },
        { merge: true }
      );

    return { reply, tokens: response.usage?.total_tokens || 0 };
  } catch (error) {
    throw new functions.https.HttpsError("internal", "Chat failed");
  }
});
