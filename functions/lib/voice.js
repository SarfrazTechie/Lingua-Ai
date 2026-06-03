"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.voiceToText = void 0;
const functions = require("firebase-functions");
const auth_check_1 = require("./middleware/auth_check");
exports.voiceToText = functions.https.onCall(async (data, context) => {
    var _a, _b, _c, _d, _e;
    (0, auth_check_1.verifyAuth)(context);
    const { audioBase64, language = "en" } = data;
    if (!audioBase64) {
        throw new functions.https.HttpsError("invalid-argument", "Audio data is required");
    }
    try {
        const apiKey = process.env.DEEPGRAM_API_KEY;
        const audioBuffer = Buffer.from(audioBase64, "base64");
        const response = await fetch(`https://api.deepgram.com/v1/listen?language=${language}&model=nova-2`, {
            method: "POST",
            headers: {
                Authorization: `Token ${apiKey}`,
                "Content-Type": "audio/wav",
            },
            body: audioBuffer,
        });
        const result = await response.json();
        const transcript = ((_e = (_d = (_c = (_b = (_a = result === null || result === void 0 ? void 0 : result.results) === null || _a === void 0 ? void 0 : _a.channels) === null || _b === void 0 ? void 0 : _b[0]) === null || _c === void 0 ? void 0 : _c.alternatives) === null || _d === void 0 ? void 0 : _d[0]) === null || _e === void 0 ? void 0 : _e.transcript) || "";
        return { transcript };
    }
    catch (error) {
        throw new functions.https.HttpsError("internal", "Voice transcription failed");
    }
});
//# sourceMappingURL=voice.js.map