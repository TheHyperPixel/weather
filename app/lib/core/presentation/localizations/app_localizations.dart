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

  String get applicationName => Intl.message(
        'Weather',
        name: 'applicationName',
        desc: 'The name of the app',
      );

  String get companyName => Intl.message(
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

  String get cityTypeTitleCardiff => Intl.message(
        'Cardiff',
        name: 'cityTypeTitleCardiff',
        desc: 'Copyright Name for location enum Cardiff',
      );

  String get cityTypeTitleCambridge => Intl.message(
        'Cambridge',
        name: 'cityTypeTitleCambridge',
        desc: 'Copyright Name for location enum Cambridge',
      );

  String get feelsLike => Intl.message(
        'Feels like',
        name: 'feelsLike',
        desc: 'feelsLike',
      );

  String get highsLows => Intl.message(
        'Highs / Lows',
        name: 'highsLows',
        desc: 'highsLows',
      );

  String get pressure => Intl.message(
        'Pressure',
        name: 'pressure',
        desc: 'pressure',
      );

  String get humidity => Intl.message(
        'Humidity',
        name: 'humidity',
        desc: 'humidity',
      );

  String get visibility => Intl.message(
        'Visibility',
        name: 'visibility',
        desc: 'visibility',
      );

  String get mapTileTypeClouds => Intl.message(
        'Clouds',
        name: 'mapTileTypeClouds',
        desc: 'mapTileTypeClouds',
      );

  String get mapTileTypeTemperature => Intl.message(
        'Temperature',
        name: 'mapTileTypeTemperature',
        desc: 'mapTileTypeTemperature',
      );

  String get mapTileTypePrecipitation => Intl.message(
        'Precipitation',
        name: 'mapTileTypePrecipitation',
        desc: 'mapTileTypePrecipitation',
      );

  String get mapTileTypeWind => Intl.message(
        'Wind',
        name: 'mapTileTypeWind',
        desc: 'mapTileTypeWind',
      );

  String get mapTileTypePressure => Intl.message(
        'Pressure',
        name: 'mapTileTypePressure',
        desc: 'mapTileTypePressure',
      );

  String get errorTitle => Intl.message(
        'Error',
        name: 'errorTitle',
        desc: 'errorTitle',
      );

  String get errorDescription => Intl.message(
        'An unknown error occured. We\'re really sorry about this. It could be your internet connection, but is more likely the servers our side. Please wait a few minutes and try again.',
        name: 'errorDescription',
        desc: 'errorDescription',
      );

  String get retry => Intl.message(
        'retry',
        name: 'retry',
        desc: 'retry',
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
