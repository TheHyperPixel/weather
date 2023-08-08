import 'package:app/core/domain/entities/coordinate.dart';
import 'package:app/core/presentation/localizations/app_localizations.dart';

enum CityType {
  norwich,
  london,
  glasgow,
  cardiff,
  cambridge,
}

extension CityTypeExtension on CityType {
  Coordinate get coordinate {
    switch (this) {
      case CityType.norwich:
        return const Coordinate(lat: 52.6293, lon: 1.2979);
      case CityType.london:
        return const Coordinate(lat: 51.5072, lon: 0.1276);
      case CityType.glasgow:
        return const Coordinate(lat: 55.8617, lon: -4.2583);
      case CityType.cardiff:
        return const Coordinate(lat: 51.4849, lon: -3.1763);
      case CityType.cambridge:
        return const Coordinate(lat: 52.2048, lon: 0.1197);
    }
  }

  String title({required AppLocalizations appLocalizations}) {
    switch (this) {
      case CityType.norwich:
        return appLocalizations.cityTypeTitleNorwich;
      case CityType.london:
        return appLocalizations.cityTypeTitleLondon;
      case CityType.glasgow:
        return appLocalizations.cityTypeTitleGlasgow;
      case CityType.cardiff:
        return appLocalizations.cityTypeTitleCardiff;
      case CityType.cambridge:
        return appLocalizations.cityTypeTitleCambridge;
    }
  }
}
