import * as functions from "firebase-functions";
import { verifyAuth } from "./middleware/auth_check";

export const voiceToText = functions.https.onCall(async (data, context) => {
  verifyAuth(context);

  const { audioBase64, language = "en" } = data;

  if (!audioBase64) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Audio data is required"
    );
  }

  try {
    const apiKey = process.env.DEEPGRAM_API_KEY;
    const audioBuffer = Buffer.from(audioBase64, "base64");

    const response = await fetch(
      `https://api.deepgram.com/v1/listen?language=${language}&model=nova-2`,
      {
        method: "POST",
        headers: {
          Authorization: `Token ${apiKey}`,
          "Content-Type": "audio/wav",
        },
        body: audioBuffer,
      }
    );

    const result = await response.json() as any;
    const transcript =
      result?.results?.channels?.[0]?.alternatives?.[0]?.transcript || "";

    return { transcript };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Voice transcription failed"
    );
  }
});
