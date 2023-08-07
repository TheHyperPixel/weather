abstract class IWeatherRepository {
  Future getWeather({required double lat, required double lon});
}
