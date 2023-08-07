part of 'weather_cubit.dart';

@immutable
class WeatherState {
  final CityType cityType;
  final UnitType unitType;

  const WeatherState({
    this.cityType = CityType.london,
    this.unitType = UnitType.metric,
  });
}

class WeatherStateInitial extends WeatherState {}

class WeatherStateLoading extends WeatherState {
  const WeatherStateLoading({
    super.unitType,
    super.cityType,
  });
}

class WeatherStateSuccess extends WeatherState {
  final Weather weather;

  const WeatherStateSuccess({
    super.unitType,
    super.cityType,
    required this.weather,
  });
}

class WeatherStateFailure extends WeatherState {
  const WeatherStateFailure({
    super.unitType,
    super.cityType,
  });
}
