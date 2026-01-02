import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();

  /// Speak Urdu text
  static Future<void> speakUrdu(String text) async {
    await _tts.stop();

    await _tts.setEngine("com.google.android.tts"); // IMPORTANT
    await _tts.setLanguage("ur-PK");                // MUST
    await _tts.setSpeechRate(0.4);                  // Slower for Urdu
    await _tts.setPitch(1.0);

    await _tts.speak(text);
  }

  /// Speak English text
  static Future<void> speakEnglish(String text) async {
    await _tts.stop();

    await _tts.setEngine("com.google.android.tts");
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);

    await _tts.speak(text);
  }

  /// Stop speaking
  static Future<void> stop() async {
    await _tts.stop();
  }
}
