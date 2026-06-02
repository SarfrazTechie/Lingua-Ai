import '../../core/errors/app_exception.dart';

class VoiceService {
  // Placeholder — Deepgram lagane ke baad implement hoga

  Future<String> speechToText(List<int> audioBytes,
      {String language = 'en'}) async {
    throw const NetworkException('Voice service not configured yet');
  }

  Future<bool> requestMicPermission() async => true;
}
