import 'package:app/core/domain/entities/weather.dart';

class WeatherDto {
  static Weather toEntity({required Map<String, dynamic> map}) {
    int _cloudCoverage = 0;
    if (map.containsKey('clouds')) {
      _cloudCoverage = map['clouds']['all'];
    }

    double _windSpeed = 0;
    if (map.containsKey('wind')) {
      _windSpeed = double.parse(map['wind']['speed'].toString());
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
      temp: double.parse(map['main']['temp'].toString()),
      tempMin: double.parse(map['main']['temp_min'].toString()),
      tempMax: double.parse(map['main']['temp_max'].toString()),
      feelsLike: double.parse(map['main']['feels_like'].toString()),
      pressure: map['main']['pressure'],
      humidity: map['main']['humidity'],
      windSpeed: _windSpeed,
      windDegree: _windDegree,
      cloudCoverage: _cloudCoverage,
      visibility: _visibility,
      principle: map['weather'][0]['main'],
      description: map['weather'][0]['description'],
      icon: map['weather'][0]['icon'],
    );
  }
}
