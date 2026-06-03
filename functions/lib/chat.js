"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.chatMessage = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const auth_check_1 = require("./middleware/auth_check");
const limit_check_1 = require("./middleware/limit_check");
exports.chatMessage = functions.https.onCall(async (data, context) => {
    var _a, _b, _c, _d;
    (0, auth_check_1.verifyAuth)(context);
    const { message, history = [], mode = "Travel Companion" } = data;
    if (!message) {
        throw new functions.https.HttpsError("invalid-argument", "Message is required");
    }
    const uid = context.auth.uid;
    await (0, limit_check_1.checkLimit)(uid);
    try {
        const Groq = (await Promise.resolve().then(() => require("groq-sdk"))).default;
        const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });
        const systemPrompt = `You are a helpful AI language assistant specializing in ${mode}.
Help the user with translations, language learning, and cultural context.
Be concise and practical.`;
        const messages = [
            { role: "system", content: systemPrompt },
            ...history.map((h) => ({
                role: h.role,
                content: h.content,
            })),
            { role: "user", content: message },
        ];
        const response = await groq.chat.completions.create({
            model: "llama3-8b-8192",
            messages,
            max_tokens: 500,
            temperature: 0.7,
        });
        const reply = ((_c = (_b = (_a = response.choices[0]) === null || _a === void 0 ? void 0 : _a.message) === null || _b === void 0 ? void 0 : _b.content) === null || _c === void 0 ? void 0 : _c.trim()) || "";
        const tokens = ((_d = response.usage) === null || _d === void 0 ? void 0 : _d.total_tokens) || 0;
        const today = new Date().toISOString().split("T")[0];
        const ref = admin.firestore().doc(`usage/${uid}/daily/${today}`);
        await ref.set({
            messageCount: admin.firestore.FieldValue.increment(1),
            tokenCount: admin.firestore.FieldValue.increment(tokens),
            lastUpdated: new Date().toISOString(),
        }, { merge: true });
        return { reply, tokens };
    }
    catch (error) {
        throw new functions.https.HttpsError("internal", "Chat failed");
    }
});
//# sourceMappingURL=chat.js.map