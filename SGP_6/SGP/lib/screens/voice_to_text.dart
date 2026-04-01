import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/speech_service.dart';
import '../services/translation_service.dart';
import '../services/database_helper.dart';
import '../models/history_item.dart';

class VoiceToTextScreen extends StatefulWidget {
  const VoiceToTextScreen({super.key});

  @override
  State<VoiceToTextScreen> createState() => _VoiceToTextScreenState();
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
  final SpeechService _speechService = SpeechService();
  final TranslationService _translationService = TranslationService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _voiceText = '';
  String _translatedText = '';
  bool _isListening = false;
  bool _isTranslating = false;

  String _speechLocale = 'en_IN';
  String _targetLangCode = 'hi';

  final Map<String, String> _speechLanguages = {
    'English': 'en_IN',
    'Hindi': 'hi_IN',
    'Gujarati': 'gu_IN',
    'Telugu': 'te_IN',
    'Tamil': 'ta_IN',
    'Kannada': 'kn_IN',
  };

  final Map<String, String> _translateLanguages = {
    'Hindi': 'hi',
    'English': 'en',
    'Gujarati': 'gu',
    'Telugu': 'te',
    'Tamil': 'ta',
    'Kannada': 'kn',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Arabic': 'ar',
    'Japanese': 'ja',
    'Chinese': 'zh',
  };

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechService.initialize();
  }

  void _toggleListening() {
    if (_isListening) {
      _speechService.stop();
      setState(() => _isListening = false);
    } else {
      setState(() {
        _isListening = true;
        _translatedText = '';
      });
      _speechService.listen(
        onResult: (result) {
          setState(() => _voiceText = result);
        },
        localeId: _speechLocale,
      );
    }
  }

  Future<void> _translate() async {
    if (_voiceText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture some voice first.')),
      );
      return;
    }
    setState(() {
      _isTranslating = true;
      _translatedText = '';
    });

    final result = await _translationService.translate(
      _voiceText,
      _targetLangCode,
    );

    setState(() {
      _translatedText = result;
      _isTranslating = false;
    });

    // Auto-save translation to history
    final item = HistoryItem(
      text: '${_voiceText}\n→ $_translatedText',
      type: 'translated',
      timestamp: DateTime.now(),
    );
    await _dbHelper.insertHistory(item);
  }

  void _clear() {
    setState(() {
      _voiceText = '';
      _translatedText = '';
    });
  }

  void _saveToHistory() async {
    final defaultText = AppLocalizations.of(context)!.translate('press_button');
    if (_voiceText.isNotEmpty && _voiceText != defaultText) {
      final item = HistoryItem(
        text: _voiceText,
        type: 'voice',
        timestamp: DateTime.now(),
      );
      await _dbHelper.insertHistory(item);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.translate('saved_to_history'),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('voice_to_text')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButton<String>(
              value: _speechLocale,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              underline: Container(),
              icon: const Icon(Icons.mic, color: Colors.white70, size: 20),
              items: _speechLanguages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _speechLocale = val);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Voice Input Section ──────────────────────────────
            _sectionLabel('🎙 Voice Input', Colors.blueAccent),
            const SizedBox(height: 8),
            _textBox(
              text: _voiceText.isEmpty
                  ? AppLocalizations.of(context)!.translate('press_button')
                  : _voiceText,
              borderColor: _isListening ? Colors.redAccent : Colors.blueAccent,
              dimmed: _voiceText.isEmpty,
            ),
            const SizedBox(height: 16),

            // ── Mic controls ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _micButton(),
                ElevatedButton.icon(
                  onPressed: _voiceText.isEmpty ? null : _saveToHistory,
                  icon: const Icon(Icons.save, size: 18),
                  label: Text(AppLocalizations.of(context)!.translate('save')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _clear,
                  icon: const Icon(Icons.clear, size: 18),
                  label: Text(AppLocalizations.of(context)!.translate('clear')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),

            // ── Translation Section ──────────────────────────────
            _sectionLabel('🌐 Translate To', Colors.tealAccent),
            const SizedBox(height: 10),

            // Target language picker
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.tealAccent.withValues(alpha: 0.4),
                ),
              ),
              child: DropdownButton<String>(
                value: _targetLangCode,
                isExpanded: true,
                dropdownColor: const Color(0xFF1E2F3C),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                underline: Container(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.tealAccent,
                ),
                items: _translateLanguages.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _targetLangCode = val;
                      _translatedText = '';
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 14),

            // Translate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isTranslating ? null : _translate,
                icon: _isTranslating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.translate_rounded),
                label: Text(
                  _isTranslating ? 'Translating...' : 'Translate',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Translation result
            if (_translatedText.isNotEmpty || _isTranslating) ...[
              _sectionLabel('📝 Translation', Colors.greenAccent),
              const SizedBox(height: 8),
              _textBox(
                text: _isTranslating ? '...' : _translatedText,
                borderColor: Colors.greenAccent,
                dimmed: _isTranslating,
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, Color color) {
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 14,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _textBox({
    required String text,
    required Color borderColor,
    bool dimmed = false,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: dimmed ? Colors.white38 : Colors.white,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _micButton() {
    return GestureDetector(
      onTap: _toggleListening,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isListening ? Colors.redAccent : Colors.blueAccent,
          boxShadow: [
            BoxShadow(
              color: (_isListening ? Colors.redAccent : Colors.blueAccent)
                  .withValues(alpha: 0.5),
              blurRadius: _isListening ? 20 : 8,
              spreadRadius: _isListening ? 4 : 0,
            ),
          ],
        ),
        child: Icon(
          _isListening ? Icons.stop_rounded : Icons.mic_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
