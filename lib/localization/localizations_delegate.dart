import 'package:flutter/material.dart';

import 'languages/language_ko.dart';
import 'languages/language_en.dart';
import 'languages/languages.dart';


class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        'en',
        'ko',
      ].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ko':
        return LanguageKo();
      default:
        return LanguageKo();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
