import 'package:app/core/domain/entities/weather.dart';
import 'package:app/core/domain/enums/city_type.dart';
import 'package:app/core/domain/enums/unit_type.dart';
import 'package:app/core/domain/repositories/i_weather_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'weather_state.dart';

@injectable
class WeatherCubit extends Cubit<WeatherState> {
  final IWeatherRepository _weatherRepository;
  UnitType _unitType = UnitType.metric;

  WeatherCubit(
    this._weatherRepository,
  ) : super(WeatherStateInitial());

  loadWeather({required CityType cityType}) async {
    try {
      emit(WeatherStateLoading(cityType: cityType));
      final Weather _weather = await _weatherRepository.getWeather(
        lat: cityType.coordinate.lat,
        lon: cityType.coordinate.lon,
        unit: _unitType.name,
      );
      emit(WeatherStateSuccess(
        cityType: cityType,
        weather: _weather,
      ));
    } catch (e) {
      emit(WeatherStateFailure(cityType: cityType));
    }
  }

  changeUnitType({required UnitType unitType}) {
    try {
      _unitType = unitType;
    } catch (e) {
      _unitType = UnitType.metric;
    }
  }
}
