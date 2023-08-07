import 'package:app/core/domain/entities/weather.dart';

class WeatherDto {
  static Weather toEntity({required Map<String, dynamic> map}) {
    int _cloudCoverage = 0;
    if (map.containsKey('clouds')) {
      _cloudCoverage = map['clouds']['all'];
    }

    double _windSpeed = 0;
    if (map.containsKey('wind')) {
      _windSpeed = map['wind']['speed'];
    }

    int _windDegree = 0;
    if (map.containsKey('wind')) {
      _windDegree = map['wind']['deg'];
    }

    int _visibility = 0;
    if (map.containsKey('visibility')) {
      _visibility = map['visibility'];
    }

    return Weather(
      uuid: map['dt'].toString(),
      temp: map['main']['temp'],
      tempMin: map['main']['temp_min'],
      tempMax: map['main']['temp_max'],
      feelsLike: map['main']['feels_like'],
      pressure: map['main']['pressure'],
      humidity: map['main']['humidity'],
      windSpeed: _windSpeed,
      windDegree: _windDegree,
      cloudCoverage: _cloudCoverage,
      visibility: _visibility,
    );
  }
}
