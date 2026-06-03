"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.resetDailyUsage = exports.chatMessage = exports.translateText = void 0;
const admin = require("firebase-admin");
admin.initializeApp();
var translate_1 = require("./translate");
Object.defineProperty(exports, "translateText", { enumerable: true, get: function () { return translate_1.translateText; } });
var chat_1 = require("./chat");
Object.defineProperty(exports, "chatMessage", { enumerable: true, get: function () { return chat_1.chatMessage; } });
var usage_1 = require("./usage");
Object.defineProperty(exports, "resetDailyUsage", { enumerable: true, get: function () { return usage_1.resetDailyUsage; } });
//# sourceMappingURL=index.js.map