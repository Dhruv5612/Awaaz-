import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

enum TranslationEngine { google, papago, deepl }

class TranslationService {
  Future<String> translate(
    String text,
    String toLanguageCode, {
    TranslationEngine engine = TranslationEngine.google,
    @Deprecated('Use engine parameter instead') bool usePapago = false,
  }) async {
    if (text.isEmpty) return '';

    // Handle deprecated boolean
    TranslationEngine effectiveEngine = engine;
    if (usePapago && engine == TranslationEngine.google) {
      effectiveEngine = TranslationEngine.papago;
    }

    switch (effectiveEngine) {
      case TranslationEngine.papago:
        return await _translateWithPapago(text, toLanguageCode);
      case TranslationEngine.deepl:
        return await _translateWithDeepL(text, toLanguageCode);
      case TranslationEngine.google:
        return await _translateWithGoogle(text, toLanguageCode);
    }
  }

  /// Uses Google Translate free API — proper Devanagari/Indian script output,
  /// auto-detects source language, CORS-compatible on Flutter Web.
  Future<String> _translateWithGoogle(
    String text,
    String toLanguageCode,
  ) async {
    try {
      final uri = Uri.parse(
        'https://translate.googleapis.com/translate_a/single'
        '?client=gtx'
        '&sl=auto'
        '&tl=$toLanguageCode'
        '&dt=t'
        '&q=${Uri.encodeComponent(text)}',
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': 'Mozilla/5.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Response format: [ [ ["translated","original",...], ... ], ... ]
        final buffer = StringBuffer();
        final segments = data[0] as List<dynamic>;
        for (final segment in segments) {
          if (segment is List && segment.isNotEmpty && segment[0] != null) {
            buffer.write(segment[0].toString());
          }
        }
        final result = buffer.toString().trim();
        return result.isNotEmpty ? result : text;
      } else {
        print('Google Translate Error: ${response.statusCode}');
        return text;
      }
    } catch (e) {
      print('Translation Error: $e');
      return text;
    }
  }

  Future<String> _translateWithPapago(
    String text,
    String toLanguageCode,
  ) async {
    try {
      // Detect language first (Papago requires source language)
      String sourceLang = await _detectLanguage(text);

      final response = await http.post(
        Uri.parse(ApiConfig.papagoTextUrl),
        headers: {
          'X-NCP-APIGW-API-KEY-ID': ApiConfig.papagoClientId,
          'X-NCP-APIGW-API-KEY': ApiConfig.papagoClientSecret,
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {'source': sourceLang, 'target': toLanguageCode, 'text': text},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['message']['result']['translatedText'];
      } else {
        print('Papago API Error: ${response.statusCode} - ${response.body}');
        return text;
      }
    } catch (e) {
      print('Papago Translation Error: $e');
      return text;
    }
  }

  Future<String> _detectLanguage(String text) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.papagoDetectUrl),
        headers: {
          'X-NCP-APIGW-API-KEY-ID': ApiConfig.papagoClientId,
          'X-NCP-APIGW-API-KEY': ApiConfig.papagoClientSecret,
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {'query': text},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['langCode'] ?? 'en';
      }
    } catch (e) {
      print('Papago Language Detection Error: $e');
    }
    return 'en'; // Default to English
  }

  Future<String> _translateWithDeepL(String text, String toLanguageCode) async {
    try {
      // DeepL uses 'EN-US' or 'EN-GB' for target, and just 'EN' is usually fine
      // Most other codes are standard ISO 639-1
      String targetLang = toLanguageCode.toUpperCase();
      if (targetLang == 'EN') targetLang = 'EN-US';

      final response = await http.post(
        Uri.parse(ApiConfig.deeplUrl),
        headers: {
          'Authorization': 'DeepL-Auth-Key ${ApiConfig.deeplApiKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'text': text, 'target_lang': targetLang},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['translations'][0]['text'];
      } else {
        print('DeepL API Error: ${response.statusCode} - ${response.body}');
        return text;
      }
    } catch (e) {
      print('DeepL Translation Error: $e');
      return text;
    }
  }
}
