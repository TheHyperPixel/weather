import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations();

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode == null || locale.countryCode!.isEmpty)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get appName => Intl.message(
        'Hyper Weather App',
        name: 'appName',
        desc: 'The name of the app',
      );

  String get tapDatLtdName => Intl.message(
        'Hyper Pixel Ltd',
        name: 'hyperPixelLtdName',
        desc: 'The name of the company',
      );

  String get copyrightText => Intl.message(
        'Copyright 2023',
        name: 'copyrightText',
        desc: 'Copyright text on the settings screen',
      );

  String get cityTypeTitleNorwich => Intl.message(
        'Norwich',
        name: 'cityTypeTitleNorwich',
        desc: 'Name for location enum Norwich',
      );
  String get cityTypeTitleLondon => Intl.message(
        'London',
        name: 'cityTypeTitleLondon',
        desc: 'Name for location enum London',
      );
  String get cityTypeTitleGlasgow => Intl.message(
        'Glasgow',
        name: 'cityTypeTitleGlasgow',
        desc: 'Name for location enum Glasgow',
      );
  String get cityTypeTitleManchester => Intl.message(
        'Manchester',
        name: 'cityTypeTitleManchester',
        desc: 'Copyright Name for location enum Manchester',
      );
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
