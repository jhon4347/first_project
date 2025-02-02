import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const _key = 'isDarkMode';

  bool _isDarkMode = false; // Initialize with a default value

  bool get isDarkMode => _isDarkMode;

  // Load the theme preference from SharedPreferences
  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode =
        prefs.getBool(_key) ?? false; // Default to light mode if not set
    notifyListeners(); // Notify listeners when theme preference is loaded
  }

  // Save the theme preference to SharedPreferences
  Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDarkMode);
    _isDarkMode = isDarkMode;
    notifyListeners(); // Notify listeners when theme preference is updated
  }

  // Toggle between light and dark mode
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await saveThemePreference(_isDarkMode); // Save the updated theme preference
  }

  // Build the light theme
  ThemeData buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      hintColor: Colors.blueAccent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Add other light theme customizations as needed
    );
  }

  // Build the dark theme
  ThemeData buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurple,
      hintColor: Colors.deepPurpleAccent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Add other dark theme customizations as needed
    );
  }

  // Get the current theme based on the stored preference
  ThemeData get currentTheme {
    return _isDarkMode ? buildDarkTheme() : buildLightTheme();
  }

  // Constructor to load the theme preference immediately
  ThemeService() {
    loadThemePreference(); // Load theme preference as soon as the service is created
  }
}
