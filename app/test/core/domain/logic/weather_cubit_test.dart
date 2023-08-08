import 'package:app/core/domain/entities/weather.dart';
import 'package:app/core/domain/enums/unit_type.dart';
import 'package:app/core/domain/logic/weather/weather_cubit.dart';
import 'package:app/core/domain/repositories/i_weather_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _WeatherRepositoryMock extends Mock implements IWeatherRepository {}

class _WeatherMock extends Mock implements Weather {}

void main() {
  late _WeatherRepositoryMock _repositoryMock;
  final _WeatherMock _weatherMock = _WeatherMock();
  final List<_WeatherMock> _forecastMock = [_WeatherMock()];

  setUp(() {
    _repositoryMock = _WeatherRepositoryMock();
  });
  group('$WeatherCubit', () {
    test('First state of Weather Cubit is Initial', () {
      final cubit = WeatherCubit(_repositoryMock);
      expect(cubit.state, WeatherStateInitial());
    });

    blocTest(
      'Load weather emits success',
      setUp: () {
        when(() => _repositoryMock.getWeather(
            lat: 0,
            lon: 0,
            unit: UnitType.metric.name)).thenAnswer((_) async => _weatherMock);
        when(() => _repositoryMock.getForecast(
            lat: 0,
            lon: 0,
            unit: UnitType.metric.name)).thenAnswer((_) async => _forecastMock);
      },
      build: () => WeatherCubit(_repositoryMock),
      act: (cubit) {
        cubit.loadAllWeather();
      },
      expect: () => [
        const WeatherStateSuccess(
          unitType: UnitType.metric,
          locations: [],
        ),
      ],
    );

    blocTest(
      'Toggling unit type changes the unit type',
      build: () => WeatherCubit(_repositoryMock),
      act: (cubit) {
        cubit.toggleUnitType();
        cubit.toggleUnitType();
        cubit.toggleUnitType();
      },
      expect: () => [
        const WeatherStateSuccess(
          unitType: UnitType.imperial,
          locations: [],
        ),
        const WeatherStateSuccess(
          unitType: UnitType.metric,
          locations: [],
        ),
        const WeatherStateSuccess(
          unitType: UnitType.imperial,
          locations: [],
        ),
      ],
    );
  });
}
