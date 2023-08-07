import 'package:app/core/domain/entities/entity.dart';
import 'package:app/core/domain/entities/weather.dart';
import 'package:app/core/domain/enums/city_type.dart';

class Location extends Entity {
  final CityType cityType;
  final Weather weather;

  Location({
    required super.uuid,
    required this.cityType,
    required this.weather,
  });
}
