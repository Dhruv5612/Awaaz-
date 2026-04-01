import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Full-screen Language Picker  (dark theme)
// ─────────────────────────────────────────────────────────────────────────────
class LanguagePickerScreen extends StatefulWidget {
  final String currentLang;
  const LanguagePickerScreen({super.key, required this.currentLang});

  @override
  State<LanguagePickerScreen> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends State<LanguagePickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  // Colours
  static const _bg = Color(0xFF000000);
  static const _surface = Color(0xFF0D0D0D);
  static const _accent = Color(0xFF3D6BE8);
  static const _accentGlow = Color(0x223D6BE8);
  static const _textPri = Color(0xFFEAEAEA);
  static const _textSec = Color(0xFF6B7280);
  static const _divider = Color(0xFF1A1A1A);

  static const List<Map<String, String>> _allLanguages = [
    {'label': 'English', 'native': 'English ', 'flag': '🇺🇸'},
    {'label': 'Afrikaans', 'native': 'Afrikaans ', 'flag': '🇿🇦'},
    {'label': 'Albanian', 'native': 'Albanian ', 'flag': '🇦🇱'},
    {'label': 'Amharic', 'native': 'Amharic ', 'flag': '🇪🇹'},
    {'label': 'Arabic', 'native': 'Arabic ', 'flag': '🇸🇦'},
    {'label': 'Armenian', 'native': 'Armenian ', 'flag': '🇦🇲'},
    {'label': 'Azerbaijani', 'native': 'Azerbaijani ', 'flag': '🇦🇿'},
    {'label': 'Basque', 'native': 'Basque ', 'flag': '🇪🇸'},
    {'label': 'Belarusian', 'native': 'Belarusian ', 'flag': '🇧🇾'},
    {'label': 'Bengali', 'native': 'Bengali ', 'flag': '🇧🇩'},
    {'label': 'Bosnian', 'native': 'Bosnian ', 'flag': '🇧🇦'},
    {'label': 'Bulgarian', 'native': 'Bulgarian ', 'flag': '🇧🇬'},
    {'label': 'Catalan', 'native': 'Catalan ', 'flag': '🇪🇸'},
    {'label': 'Cebuano', 'native': 'Cebuano ', 'flag': '🇵🇭'},
    {'label': 'Chinese (Simplified)', 'native': '中文 ', 'flag': '🇨🇳'},
    {'label': 'Chinese (Traditional)', 'native': '中文 ', 'flag': '🇹🇼'},
    {'label': 'Croatian', 'native': 'Croatian ', 'flag': '🇭🇷'},
    {'label': 'Czech', 'native': 'Czech ', 'flag': '🇨🇿'},
    {'label': 'Danish', 'native': 'Danish ', 'flag': '🇩🇰'},
    {'label': 'Dutch', 'native': 'Dutch ', 'flag': '🇳🇱'},
    {'label': 'Finnish', 'native': 'Finnish ', 'flag': '🇫🇮'},
    {'label': 'French', 'native': 'French ', 'flag': '🇫🇷'},
    {'label': 'Galician', 'native': 'Galician ', 'flag': '🇪🇸'},
    {'label': 'Georgian', 'native': 'Georgian ', 'flag': '🇬🇪'},
    {'label': 'German', 'native': 'German ', 'flag': '🇩🇪'},
    {'label': 'Greek', 'native': 'Greek ', 'flag': '🇬🇷'},
    {'label': 'Gujarati', 'native': 'Gujarati ', 'flag': '🇮🇳'},
    {'label': 'Haitian Creole', 'native': 'Haitian Creole ', 'flag': '🇭🇹'},
    {'label': 'Hebrew', 'native': 'Hebrew ', 'flag': '🇮🇱'},
    {'label': 'Hindi', 'native': 'Hindi ', 'flag': '🇮🇳'},
    {'label': 'Hungarian', 'native': 'Hungarian ', 'flag': '🇭🇺'},
    {'label': 'Indonesian', 'native': 'Indonesian ', 'flag': '🇮🇩'},
    {'label': 'Irish', 'native': 'Irish ', 'flag': '🇮🇪'},
    {'label': 'Italian', 'native': 'Italian ', 'flag': '🇮🇹'},
    {'label': 'Japanese', 'native': 'Japanese ', 'flag': '🇯🇵'},
    {'label': 'Kannada', 'native': 'Kannada', 'flag': '🇮🇳'},
    {'label': 'Korean', 'native': 'Korean ', 'flag': '🇰🇷'},
    {'label': 'Latin', 'native': 'Latin ', 'flag': '🏛️'},
    {'label': 'Latvian', 'native': 'Latvian ', 'flag': '🇱🇻'},
    {'label': 'Lithuanian', 'native': 'Lithuanian ', 'flag': '🇱🇹'},
    {'label': 'Macedonian', 'native': 'Macedonian ', 'flag': '🇲🇰'},
    {'label': 'Malay', 'native': 'Malay ', 'flag': '🇲🇾'},
    {'label': 'Malayalam', 'native': 'Malayalam ', 'flag': '🇮🇳'},
    {'label': 'Maltese', 'native': 'Maltese ', 'flag': '🇲🇹'},
    {'label': 'Marathi', 'native': 'Marathi ', 'flag': '🇮🇳'},
    {'label': 'Nepali', 'native': 'Nepali ', 'flag': '🇳🇵'},
    {'label': 'Norwegian', 'native': 'Norwegian ', 'flag': '🇳🇴'},
    {'label': 'Persian', 'native': 'Persian ', 'flag': '🇮🇷'},
    {'label': 'Polish', 'native': 'Polish ', 'flag': '🇵🇱'},
    {'label': 'Portuguese', 'native': 'Portuguese ', 'flag': '🇵🇹'},
    {'label': 'Punjabi', 'native': 'Punjabi ', 'flag': '🇮🇳'},
    {'label': 'Romanian', 'native': 'Romanian ', 'flag': '🇷🇴'},
    {'label': 'Russian', 'native': 'Russian ', 'flag': '🇷🇺'},
    {'label': 'Serbian', 'native': 'Serbian ', 'flag': '🇷🇸'},
    {'label': 'Sinhala', 'native': 'Sinhala ', 'flag': '🇱🇰'},
    {'label': 'Slovak', 'native': 'Slovak ', 'flag': '🇸🇰'},
    {'label': 'Slovenian', 'native': 'Slovenian ', 'flag': '🇸🇮'},
    {'label': 'Spanish', 'native': 'Spanish ', 'flag': '🇪🇸'},
    {'label': 'Swahili', 'native': 'Swahili ', 'flag': '🇰🇪'},
    {'label': 'Swedish', 'native': 'Swedish ', 'flag': '🇸🇪'},
    {'label': 'Tamil', 'native': 'Tamil ', 'flag': '🇮🇳'},
    {'label': 'Telugu', 'native': 'Telugu ', 'flag': '🇮🇳'},
    {'label': 'Thai', 'native': 'Thai ', 'flag': '🇹🇭'},
    {'label': 'Turkish', 'native': 'Turkish ', 'flag': '🇹🇷'},
    {'label': 'Ukrainian', 'native': 'Ukrainian ', 'flag': '🇺🇦'},
    {'label': 'Urdu', 'native': 'Urdu ', 'flag': '🇵🇰'},
    {'label': 'Vietnamese', 'native': 'Vietnamese ', 'flag': '🇻🇳'},
    {'label': 'Welsh', 'native': 'Welsh ', 'flag': '🏴󠁧󠁢󠁷󠁬󠁳󠁿'},
    {'label': 'Zulu', 'native': 'Zulu ', 'flag': '🇿🇦'},
  ];

  List<Map<String, String>> get _filtered {
    if (_query.isEmpty) return _allLanguages;
    final q = _query.toLowerCase();
    return _allLanguages
        .where(
          (l) =>
              l['label']!.toLowerCase().contains(q) ||
              l['native']!.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textPri),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Language',
          style: TextStyle(
            color: _textPri,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _divider),
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────
          Container(
            color: _surface,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: _textPri),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search language…',
                hintStyle: const TextStyle(color: _textSec),
                prefixIcon: const Icon(Icons.search, color: _textSec),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // ── Language list ────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 72, color: _divider),
              itemBuilder: (ctx, i) {
                final lang = filtered[i];
                final isSelected = lang['label'] == widget.currentLang;
                return Material(
                  color: isSelected ? _accentGlow : Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context, lang['label']),
                    splashColor: _accentGlow,
                    highlightColor: _accentGlow,
                    child: Container(
                      decoration: isSelected
                          ? const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: _accent, width: 3),
                              ),
                            )
                          : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang['label']!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected ? _accent : _textPri,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lang['native']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: _textSec,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: _accent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
