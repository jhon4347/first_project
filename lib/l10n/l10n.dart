import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class L10n {
  static const all = [
    Locale('en', ''),
    Locale('es', ''),
    // Add more supported locales here
  ];

  static const delegate = AppLocalizationsDelegate();
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return L10n.all.contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  String get title {
    switch (locale.languageCode) {
      case 'en':
        return 'Chat App';
      case 'es':
        return 'Aplicación de Chat';
      default:
        return 'Chat App';
    }
  }
}
