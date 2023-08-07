import 'package:app/core/domain/entities/coordinate.dart';

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
        return Coordinate(lat: 52.6293, lon: 1.2979);
      case CityType.london:
        return Coordinate(lat: 51.5072, lon: 0.1276);
      case CityType.glasgow:
        return Coordinate(lat: 55.8617, lon: 4.2583);
      case CityType.manchester:
        return Coordinate(lat: 53.4808, lon: 2.2426);
    }
  }
}
