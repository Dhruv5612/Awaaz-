import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home.dart';
import 'screens/voice_to_text.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/document_translator_screen.dart';
import 'providers/language_provider.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const AwaazApp());
}

class AwaazApp extends StatefulWidget {
  const AwaazApp({super.key});

  @override
  State<AwaazApp> createState() => _AwaazAppState();

  // Static accessor for LanguageProvider to allow access from anywhere
  static LanguageProvider of(BuildContext context) {
    return context.findAncestorStateOfType<_AwaazAppState>()!._languageProvider;
  }
}

class _AwaazAppState extends State<AwaazApp> {
  final LanguageProvider _languageProvider = LanguageProvider();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _languageProvider,
      builder: (context, child) {
        return MaterialApp(
          title: 'Awaaz',
          debugShowCheckedModeBanner: false,
          locale: _languageProvider.currentLocale,
          supportedLocales: const [
            Locale('en', ''),
            Locale('hi', ''),
            Locale('gu', ''),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            // Accessibility: Large text and high contrast
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodyLarge: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          builder: (context, child) {
            // If web, constrain the width to simulate mobile
            // foundation.kIsWeb needs 'package:flutter/foundation.dart'
            if (child == null) return const SizedBox.shrink();

            // We can check strictly for web, or just always constrain on large screens
            // Here we'll use a simple Center + ConstrainedBox approach
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: child,
              ),
            );
          },
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/voice': (context) => const VoiceToTextScreen(),
            '/history': (context) => const HistoryScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/favourites': (context) => const FavouritesScreen(),
            '/ai-chat': (context) => const AIChatScreen(),
            '/doc-translator': (context) => const DocumentTranslatorScreen(),
          },
        );
      },
    );
  }
}
