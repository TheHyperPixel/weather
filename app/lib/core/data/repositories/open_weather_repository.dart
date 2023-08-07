import 'package:app/core/data/client/api_client.dart';
import 'package:app/core/data/constants/data_constants.dart';
import 'package:app/core/data/exceptions/api_client_exception.dart';
import 'package:app/core/domain/repositories/i_weather_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IWeatherRepository)
class FirebaseAuthenticationRepository implements IWeatherRepository {
  final ApiClient apiClient;

  FirebaseAuthenticationRepository(this.apiClient);

  @override
  Future getWeather({required double lat, required double lon}) async {
    try {
      Map<String, dynamic> _map = await this.apiClient.get(
          apiEndpoint:
              'weather?lat=$lat&lon=$lon&appid=${DataConstants.appId}');
    } catch (e) {
      throw ApiClientException(originalException: e);
    }
  }
}
