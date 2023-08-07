import 'package:app/core/domain/entities/entity.dart';
import 'package:app/core/domain/entities/weather.dart';
import 'package:app/core/domain/enums/city_type.dart';

class Location extends Entity {
  final CityType cityType;
  final Weather weather;
  final List<Weather> forecast;

  Location({
    required super.uuid,
    required this.cityType,
    required this.weather,
    required this.forecast,
  });
}
