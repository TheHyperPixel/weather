part of 'weather_cubit.dart';

@immutable
class WeatherState extends Equatable {
  final UnitType unitType;

  const WeatherState({
    this.unitType = UnitType.metric,
  });

  @override
  List<Object?> get props => [
        this.unitType,
      ];
}

class WeatherStateInitial extends WeatherState {}

class WeatherStateLoading extends WeatherState {
  const WeatherStateLoading({
    super.unitType,
  });
}

class WeatherStateSuccess extends WeatherState {
  final List<Location> locations;

  const WeatherStateSuccess({
    super.unitType,
    required this.locations,
  });

  @override
  List<Object?> get props => [
        this.unitType,
        this.locations,
      ];
}

class WeatherStateFailure extends WeatherState {
  const WeatherStateFailure({
    super.unitType,
  });
}
