"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.translateText = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const auth_check_1 = require("./middleware/auth_check");
const limit_check_1 = require("./middleware/limit_check");
exports.translateText = functions.https.onCall(async (data, context) => {
    var _a, _b, _c, _d;
    (0, auth_check_1.verifyAuth)(context);
    const { text, sourceLang, targetLang, tone = "neutral" } = data;
    if (!text || !sourceLang || !targetLang) {
        throw new functions.https.HttpsError("invalid-argument", "Missing required fields");
    }
    if (text.length > 500) {
        throw new functions.https.HttpsError("invalid-argument", "Text too long. Max 500 characters.");
    }
    const uid = context.auth.uid;
    await (0, limit_check_1.checkLimit)(uid);
    try {
        const Groq = (await Promise.resolve().then(() => require("groq-sdk"))).default;
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
        const translation = ((_c = (_b = (_a = response.choices[0]) === null || _a === void 0 ? void 0 : _a.message) === null || _b === void 0 ? void 0 : _b.content) === null || _c === void 0 ? void 0 : _c.trim()) || "";
        const tokens = ((_d = response.usage) === null || _d === void 0 ? void 0 : _d.total_tokens) || 0;
        const today = new Date().toISOString().split("T")[0];
        const ref = admin.firestore().doc(`usage/${uid}/daily/${today}`);
        await ref.set({
            messageCount: admin.firestore.FieldValue.increment(1),
            tokenCount: admin.firestore.FieldValue.increment(tokens),
            lastUpdated: new Date().toISOString(),
        }, { merge: true });
        return { translation, tokens };
    }
    catch (error) {
        throw new functions.https.HttpsError("internal", "Translation failed");
    }
});
//# sourceMappingURL=translate.js.map