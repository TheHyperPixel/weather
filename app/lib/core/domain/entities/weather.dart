import 'package:app/core/domain/entities/entity.dart';
import 'package:app/core/domain/enums/unit_type.dart';

class Weather extends Entity {
  final double temp;
  final double tempMin;
  final double tempMax;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final int cloudCoverage;
  final int visibility;
  final String principle;
  final String description;
  final String icon;
  final UnitType unitType;

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
    required this.principle,
    required this.description,
    required this.icon,
    this.unitType = UnitType.metric,
  });

  Weather copyWith({
    double? temp,
    double? tempMin,
    double? tempMax,
    double? feelsLike,
    int? pressure,
    int? humidity,
    double? windSpeed,
    int? windDegree,
    int? cloudCoverage,
    int? visibility,
    String? principle,
    String? description,
    String? icon,
    UnitType? unitType,
  }) {
    return Weather(
      uuid: super.uuid,
      temp: temp ?? this.temp,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      feelsLike: feelsLike ?? this.feelsLike,
      pressure: pressure ?? this.pressure,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      windDegree: windDegree ?? this.windDegree,
      cloudCoverage: cloudCoverage ?? this.cloudCoverage,
      visibility: visibility ?? this.visibility,
      principle: principle ?? this.principle,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }
}
