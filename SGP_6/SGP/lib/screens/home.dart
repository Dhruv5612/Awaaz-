import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'language_picker_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomIndex = 0;
  String _sourceLang = 'English';
  String _targetLang = 'Gujarati';
  final TextEditingController _textController = TextEditingController();

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = temp;
    });
  }

  Future<void> _showLangPicker(bool isSource) async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (ctx) => LanguagePickerScreen(
          currentLang: isSource ? _sourceLang : _targetLang,
        ),
      ),
    );
    if (selected != null) {
      setState(() {
        if (isSource) {
          _sourceLang = selected;
        } else {
          _targetLang = selected;
        }
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AI Translator',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium, color: Color(0xFFFFB300)),
            onPressed: () {},
            tooltip: 'Premium',
          ),
          IconButton(
            icon: const Icon(Icons.settings_suggest_rounded,
                color: Colors.black54),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Language selector row ──────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _showLangPicker(true),
                      child: Text(
                        _sourceLang,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _swapLanguages,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(
                        Icons.swap_horiz,
                        color: Colors.black54,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _showLangPicker(false),
                      child: Text(
                        _targetLang,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Text input card ────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Tap to enter text',
                      hintStyle:
                          TextStyle(color: Colors.black38, fontSize: 16),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: () => Navigator.pushNamed(context, '/favourites'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Paste button
                      GestureDetector(
                        onTap: () async {
                          final data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          if (data?.text != null) {
                            _textController.text = data!.text!;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.content_paste_rounded,
                                  size: 16, color: Color(0xFF3D6BE8)),
                              SizedBox(width: 5),
                              Text(
                                'Paste',
                                style: TextStyle(
                                  color: Color(0xFF3D6BE8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Star / Favourites button
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/favourites'),
                        child: Container(
                          width: 42,
                          height: 42,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFFFB300), width: 1.5),
                          ),
                          child: const Icon(Icons.star_rounded,
                              color: Color(0xFFFFB300), size: 22),
                        ),
                      ),
                      // Microphone FAB
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/voice'),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3D6BE8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.mic,
                              color: Colors.white, size: 26),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── AI Chat Assistant banner ───────────────────────────────
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/ai-chat'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Robot emoji-style icon using a gradient circle
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF7043), Color(0xFFFFB300)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.smart_toy_rounded,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Chat Assistant',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Ask me anything',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward,
                          color: Color(0xFFE91E63), size: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── 2×2 Feature grid ──────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildFeatureCard(
                        icon: Icons.camera_alt_rounded,
                        iconBgColor: const Color(0xFFE0F2F1),
                        iconColor: const Color(0xFF00897B),
                        label: 'Camera',
                        onTap: () {},
                      ),
                      const SizedBox(height: 14),
                      _buildFeatureCard(
                        icon: Icons.description_rounded,
                        iconBgColor: const Color(0xFFE3F2FD),
                        iconColor: const Color(0xFF1E88E5),
                        label: 'Doc Translator',
                        onTap: () => Navigator.pushNamed(context, '/doc-translator'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    children: [
                      _buildFeatureCard(
                        icon: Icons.message_rounded,
                        iconBgColor: const Color(0xFFEDE7F6),
                        iconColor: const Color(0xFF7B1FA2),
                        label: 'Talking Translator',
                        onTap: () => Navigator.pushNamed(context, '/voice'),
                      ),
                      const SizedBox(height: 14),
                      _buildFeatureCard(
                        icon: Icons.grid_view_rounded,
                        iconBgColor: const Color(0xFFF3E5F5),
                        iconColor: const Color(0xFF8E24AA),
                        label: 'Others',
                        onTap: () => Navigator.pushNamed(context, '/history'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // ── Bottom Navigation Bar ──────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() => _currentBottomIndex = index);
          switch (index) {
            case 0:
              break; // already home
            case 1:
              Navigator.pushNamed(context, '/voice');
              break;
            case 2:
              Navigator.pushNamed(context, '/favourites');
              break;
            case 3:
              Navigator.pushNamed(context, '/history');
              break;
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3D6BE8),
        unselectedItemColor: Colors.black38,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Conversation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.translate_rounded),
            label: 'Dictionary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Phrases',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

