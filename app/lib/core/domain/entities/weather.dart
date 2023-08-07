import 'package:app/core/domain/entities/entity.dart';

class Weather extends Entity {
  final double temp;
  final double tempMin;
  final double tempMax;
  final double feelsLike;
  final double pressure;
  final double humidity;
  final double windSpeed;
  final int windDegree;
  final int cloudCoverage;
  final int visibility;

  Weather({
    required super.uuid,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.cloudCoverage,
    required this.visibility,
  });
}
