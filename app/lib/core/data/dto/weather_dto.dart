import 'package:app/core/domain/entities/weather.dart';

class WeatherDto {
  static Weather toEntity({required Map<String, dynamic> map}) {
    return Weather(
      uuid: map['dt'],
      temp: map['main']['temp'],
      tempMin: map['main']['temp_min'],
      tempMax: map['main']['temp_max'],
      feelsLike: map['main']['feels_like'],
      pressure: map['main']['pressure'],
      humidity: map['main']['humidity'],
      windSpeed: map['wind']['speed'],
      windDegree: map['wind']['deg'],
      cloudCoverage: map['clouds']['coverage'],
      visibility: map['visibility'],
    );
  }
}
