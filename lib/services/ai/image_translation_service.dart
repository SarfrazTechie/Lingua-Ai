import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ImageTranslationService {
  TextRecognizer? _recognizer;

  TextRecognizer get _textRecognizer {
    _recognizer ??= TextRecognizer();
    return _recognizer!;
  }

  Future<String?> extractTextFromFile(String imagePath) async {
    final inputImage = InputImage.fromFile(File(imagePath));
    final recognized = await _textRecognizer.processImage(inputImage);
    final text = recognized.text.trim();
    return text.isEmpty ? null : text;
  }

  void dispose() {
    _recognizer?.close();
    _recognizer = null;
  }
}
