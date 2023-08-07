import 'package:app/core/data/client/api_client.dart';
import 'package:app/core/data/constants/data_constants.dart';
import 'package:app/core/data/dto/forecast_dto.dart';
import 'package:app/core/data/dto/weather_dto.dart';
import 'package:app/core/data/exceptions/api_client_exception.dart';
import 'package:app/core/domain/entities/weather.dart';
import 'package:app/core/domain/repositories/i_weather_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IWeatherRepository)
class OpenWeatherRepository implements IWeatherRepository {
  final ApiClient apiClient;

  OpenWeatherRepository(this.apiClient);

  @override
  Future<Weather> getWeather({
    required double lat,
    required double lon,
    required String unit,
  }) async {
    try {
      Map<String, dynamic> _map = await this.apiClient.get(
        apiEndpoint: '/data/2.5/weather',
        apiQueryParams: {
          'lat': lat.toString(),
          'lon': lon.toString(),
          'units': unit,
          'appid': DataConstants.appId.toString(),
        },
      );

      return WeatherDto.toEntity(map: _map);
    } catch (e) {
      throw ApiClientException(originalException: e);
    }
  }

  @override
  Future<List<Weather>> getForecast(
      {required double lat, required double lon, required String unit}) async {
    try {
      Map<String, dynamic> _map = await this.apiClient.get(
        apiEndpoint: '/data/2.5/forecast',
        apiQueryParams: {
          'lat': lat.toString(),
          'lon': lon.toString(),
          'units': unit,
          'appid': DataConstants.appId.toString(),
        },
      );

      return ForecastDto.toEntity(map: _map);
    } catch (e) {
      throw ApiClientException(originalException: e);
    }
  }
}
