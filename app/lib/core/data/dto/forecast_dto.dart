import 'package:app/core/data/dto/weather_dto.dart';
import 'package:app/core/domain/entities/weather.dart';

class ForecastDto {
  static List<Weather> toEntity({required Map<String, dynamic> map}) {
    List<Weather> _forecast = [];

    if (map.containsKey('list')) {
      for (Map<String, dynamic> _weatherMap in map['list']) {
        _forecast.add(WeatherDto.toEntity(map: _weatherMap));
      }
    }
    return _forecast;
  }
}
