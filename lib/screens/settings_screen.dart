import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load user settings from shared preferences
  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _language = prefs.getString('language') ?? 'en';
    });
  }

  // Save user settings to shared preferences
  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _isDarkMode);
    prefs.setBool('notificationsEnabled', _isNotificationsEnabled);
    prefs.setString('language', _language);
  }

  // Toggle dark mode
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _saveSettings();
  }

  // Toggle notifications
  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
    _saveSettings();
  }

  // Change language
  void _changeLanguage(String value) {
    setState(() {
      _language = value;
    });
    _saveSettings();
  }

  // Sign out user
  Future<void> _signOut() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dark Mode Toggle
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),

            // Notifications Toggle
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: _isNotificationsEnabled,
              onChanged: _toggleNotifications,
            ),

            // Language Selection
            ListTile(
              title: Text('Language'),
              subtitle: Text(_language == 'en' ? 'English' : 'Other Language'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showLanguageDialog();
              },
            ),

            // Other Settings
            // Add other settings options as needed
          ],
        ),
      ),
    );
  }

  // Show language selection dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                onTap: () {
                  _changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Other Language'),
                onTap: () {
                  _changeLanguage('other');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
