import 'package:app/core/domain/entities/location.dart';
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

  loadAllWeather() async {
    try {
      Set<Location> _locations = {};
      for (CityType _cityType in CityType.values) {
        try {
          Location _location = Location(
            uuid: _cityType.index.toString(),
            cityType: _cityType,
            weather: await _loadWeather(cityType: _cityType),
          );
          _locations.add(_location);
        } catch (e) {
          //gracefully ignore single location weather API error
        }
      }

      if (_locations.isNotEmpty) {
        emit(WeatherStateSuccess(locations: _locations));
        return;
      }
      emit(const WeatherStateFailure());
    } catch (e) {
      emit(const WeatherStateFailure());
    }
  }

  Future<Weather> _loadWeather({required CityType cityType}) async {
    try {
      return await _weatherRepository.getWeather(
        lat: cityType.coordinate.lat,
        lon: cityType.coordinate.lon,
        unit: _unitType.name,
      );
    } catch (e) {
      rethrow;
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
