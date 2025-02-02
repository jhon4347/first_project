import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Keys for shared preferences
  static const String _themeKey = 'theme';
  static const String _languageKey = 'language';

  // Default values for settings
  static const String _defaultTheme = 'light';
  static const String _defaultLanguage = 'en';

  // Load current theme from shared preferences
  Future<String> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? _defaultTheme;
  }

  // Save theme to shared preferences
  Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }

  // Load current language from shared preferences
  Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? _defaultLanguage;
  }

  // Save language to shared preferences
  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  // Reset to default settings
  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeKey);
    await prefs.remove(_languageKey);
  }
}
