import 'package:flutter/material.dart';

class ThemeWidget extends StatelessWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  const ThemeWidget({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        'Dark Mode',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      value: isDarkMode,
      onChanged: (bool value) {
        toggleTheme(value);
      },
      secondary: Icon(
        isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      activeColor: Colors.blueAccent,
    );
  }
}
