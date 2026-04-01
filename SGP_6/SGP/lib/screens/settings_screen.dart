import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  double _volume = 0.8;
  String _themeColor = 'Blue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('settings_title')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            AppLocalizations.of(context)!.translate('preferences'),
          ),
          Card(
            color: Colors.grey[900]?.withValues(alpha: 0.8),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(
                      context,
                    )!.translate('enable_notifications'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(
                      context,
                    )!.translate('notifications_subtitle'),
                    style: const TextStyle(color: Colors.white54),
                  ),
                  value: _notificationsEnabled,
                  onChanged: (val) =>
                      setState(() => _notificationsEnabled = val),
                  activeThumbColor: Colors.blueAccent,
                ),
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!.translate('biometric_login'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(
                      context,
                    )!.translate('biometric_subtitle'),
                    style: const TextStyle(color: Colors.white54),
                  ),
                  value: _biometricEnabled,
                  onChanged: (val) => setState(() => _biometricEnabled = val),
                  activeThumbColor: Colors.blueAccent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            AppLocalizations.of(context)!.translate('audio_performance'),
          ),
          Card(
            color: Colors.grey[900]?.withValues(alpha: 0.8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppLocalizations.of(context)!.translate('app_volume'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Slider(
                    value: _volume,
                    onChanged: (val) => setState(() => _volume = val),
                    activeColor: Colors.greenAccent,
                    inactiveColor: Colors.white24,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            AppLocalizations.of(context)!.translate('appearance'),
          ),
          Card(
            color: Colors.grey[900]?.withValues(alpha: 0.8),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.translate('accent_color'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: DropdownButton<String>(
                    value: _themeColor,
                    dropdownColor: Colors.grey[900],
                    style: const TextStyle(color: Colors.blueAccent),
                    underline: Container(),
                    items: ['Blue', 'Green', 'Purple', 'Red'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _themeColor = val);
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.translate('app_language'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: DropdownButton<String>(
                    value: AwaazApp.of(context).currentLocale.languageCode,
                    dropdownColor: Colors.grey[900],
                    style: const TextStyle(color: Colors.blueAccent),
                    underline: Container(),
                    items: [
                      const DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      const DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                      const DropdownMenuItem(
                        value: 'gu',
                        child: Text('Gujarati'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        AwaazApp.of(context).changeLanguage(Locale(val));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.translate('settings_saved'),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.translate('save_settings'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
