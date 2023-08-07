import 'package:app/core/domain/entities/coordinate.dart';
import 'package:app/core/presentation/localizations/app_localizations.dart';

enum CityType {
  norwich,
  london,
  glasgow,
  manchester,
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
      case CityType.manchester:
        return const Coordinate(lat: 53.4808, lon: 2.2426);
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
      case CityType.manchester:
        return appLocalizations.cityTypeTitleManchester;
    }
  }
}
