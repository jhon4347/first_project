import 'package:first_project/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase/firebase_config.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'utils/theme_service.dart';
import 'l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    // ignore: avoid_print
    print("Firebase initialization error: $e");
    // Show a friendly error message or a fallback UI here if needed
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer2<AuthService, ThemeService>(
        builder: (context, authService, themeService, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat App',
            theme: themeService.currentTheme,
            locale: Locale(
                authService.languageCode ?? 'en'), // Default to 'en' if null
            supportedLocales: L10n.all,
            localizationsDelegates: [
              L10n.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: _getInitialScreen(authService),
          );
        },
      ),
    );
  }

  // Return either Home Screen or Login Screen based on authentication status
  Widget _getInitialScreen(AuthService authService) {
    if (authService.isAuthenticated) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
