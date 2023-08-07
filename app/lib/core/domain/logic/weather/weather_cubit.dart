import 'package:app/core/domain/entities/location.dart';
import 'package:app/core/domain/entities/weather.dart';
import 'package:app/core/domain/enums/city_type.dart';
import 'package:app/core/domain/enums/unit_type.dart';
import 'package:app/core/domain/repositories/i_weather_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

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
            forecast: await _loadForecast(cityType: _cityType),
          );
          _location.forecast.sort((a, b) => a.dateTime.compareTo(b.dateTime));
          _locations.add(_location);
        } catch (e) {
          //gracefully ignore single location weather API error
          if (kDebugMode) {
            print(e);
          }
        }
      }

      if (_locations.isNotEmpty) {
        emit(WeatherStateSuccess(locations: _locations.toList()));
        return;
      }
      emit(const WeatherStateFailure());
    } catch (e) {
      emit(const WeatherStateFailure());
    }
  }

  Future<Weather> _loadWeather({required CityType cityType}) async {
    try {
      Weather _weather = await _weatherRepository.getWeather(
        lat: cityType.coordinate.lat,
        lon: cityType.coordinate.lon,
        unit: _unitType.name,
      );
      _weather = _weather.copyWith(unitType: _unitType);
      return _weather;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Weather>> _loadForecast({required CityType cityType}) async {
    try {
      List<Weather> _forecast = await _weatherRepository.getForecast(
        lat: cityType.coordinate.lat,
        lon: cityType.coordinate.lon,
        unit: _unitType.name,
      );
      return _forecast.map((e) => e.copyWith(unitType: _unitType)).toList();
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
