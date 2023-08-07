import 'package:app/core/domain/entities/weather.dart';

abstract class IWeatherRepository {
  Future<Weather> getWeather({
    required double lat,
    required double lon,
    required String unit,
  });
}
