import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;

  Future<bool> initialize() async {
    _isAvailable = await _speech.initialize(
      onError: (val) => debugPrint('Speech Error: $val'),
      onStatus: (val) => debugPrint('Speech Status: $val'),
    );
    return _isAvailable;
  }

  void listen({
    required Function(String) onResult,
    String localeId = 'en_IN',
  }) async {
    if (_isAvailable) {
      await _speech.listen(
        onResult: (val) => onResult(val.recognizedWords),
        localeId: localeId,
      );
    }
  }

  void stop() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
}
