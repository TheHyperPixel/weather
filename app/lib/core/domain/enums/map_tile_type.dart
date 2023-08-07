import 'package:app/core/presentation/localizations/app_localizations.dart';

enum MapTileType {
  clouds,
  temperature,
  precipitation,
  wind,
  pressure,
}

extension MapTileTypeExtension on MapTileType {
  String get apiName {
    switch (this) {
      case MapTileType.clouds:
        return 'clouds_new';
      case MapTileType.temperature:
        return 'temp_new';
      case MapTileType.precipitation:
        return 'precipitation_new';
      case MapTileType.wind:
        return 'wind_new';
      case MapTileType.pressure:
        return 'pressure_new';
    }
  }

  String title({required AppLocalizations appLocalizations}) {
    switch (this) {
      case MapTileType.clouds:
        return appLocalizations.mapTileTypeClouds;
      case MapTileType.temperature:
        return appLocalizations.mapTileTypeTemperature;
      case MapTileType.precipitation:
        return appLocalizations.mapTileTypePrecipitation;
      case MapTileType.wind:
        return appLocalizations.mapTileTypeWind;
      case MapTileType.pressure:
        return appLocalizations.mapTileTypePressure;
    }
  }
}
