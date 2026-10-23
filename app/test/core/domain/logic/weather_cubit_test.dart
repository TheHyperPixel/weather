import 'package:app/core/domain/entities/location.dart';
import 'package:app/core/domain/entities/weather.dart';
import 'package:app/core/domain/enums/city_type.dart';
import 'package:app/core/domain/enums/unit_type.dart';
import 'package:app/core/domain/logic/weather/weather_cubit.dart';
import 'package:app/core/domain/repositories/i_weather_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class _WeatherRepositoryMock extends Mock implements IWeatherRepository {}

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

Weather _makeWeather({
  String uuid = 'test-weather',
  double temp = 20.0,
  double tempMin = 18.0,
  double tempMax = 22.0,
  double feelsLike = 19.0,
  int pressure = 1013,
  int humidity = 65,
  double windSpeed = 5.0,
  int windDegree = 180,
  int cloudCoverage = 20,
  int visibility = 10000,
  String principle = 'Clear',
  String description = 'clear sky',
  String icon = '01d',
  UnitType unitType = UnitType.metric,
  DateTime? dateTime,
}) {
  return Weather(
    uuid: uuid,
    temp: temp,
    tempMin: tempMin,
    tempMax: tempMax,
    feelsLike: feelsLike,
    pressure: pressure,
    humidity: humidity,
    windSpeed: windSpeed,
    windDegree: windDegree,
    cloudCoverage: cloudCoverage,
    visibility: visibility,
    principle: principle,
    description: description,
    icon: icon,
    unitType: unitType,
    dateTime: dateTime ?? DateTime.now(),
  );
}

List<Weather> _makeForecast(int count, {UnitType unitType = UnitType.metric}) {
  return List.generate(
    count,
    (index) => _makeWeather(
      uuid: 'forecast-$index',
      dateTime: DateTime.now().add(Duration(hours: index * 3)),
      unitType: unitType,
    ),
  );
}

Location _makeLocation({
  required CityType cityType,
  Weather? weather,
  List<Weather>? forecast,
}) {
  return Location(
    uuid: cityType.index.toString(),
    cityType: cityType,
    weather: weather ?? _makeWeather(),
    forecast: forecast ?? _makeForecast(8),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late _WeatherRepositoryMock repositoryMock;

  setUp(() {
    repositoryMock = _WeatherRepositoryMock();
    // Register fallback values so unstubbed calls don't throw
    registerFallbackValue(UnitType.metric);
    registerFallbackValue(UnitType.imperial);
  });

  group('WeatherCubit', () {
    // ---- Initial state ----

    test('First state of WeatherCubit is WeatherStateInitial', () {
      final cubit = WeatherCubit(repositoryMock);
      expect(cubit.state, WeatherStateInitial());
    });

    // ---- loadAllWeather — success (all 5 cities) ----

    blocTest<WeatherCubit, WeatherState>(
      'loadAllWeather emits success with all 5 cities when all API calls succeed',
      setUp: () {
        // Setup mock responses for all 5 cities
        for (final cityType in CityType.values) {
          when(
            () => repositoryMock.getWeather(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeWeather());

          when(
            () => repositoryMock.getForecast(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeForecast(8));
        }
      },
      build: () => WeatherCubit(repositoryMock),
      act: (cubit) async {
        await cubit.loadAllWeather();
      },
      expect: () => [isA<WeatherStateSuccess>()],
      verify: (cubit) {
        final successState = cubit.state as WeatherStateSuccess;
        expect(successState.locations.length, CityType.values.length);
        expect(successState.unitType, UnitType.metric);

        // Verify all 5 cities are present
        for (final cityType in CityType.values) {
          final location = successState.locations.firstWhere(
            (loc) => loc.cityType == cityType,
            orElse: () =>
                throw StateError('Missing location for $cityType'),
          );
          expect(location.cityType, cityType);
          expect(location.weather, isNotNull);
          expect(location.forecast, isNotEmpty);
          expect(location.forecast.length, 8);
        }
      },
    );

    // ---- loadAllWeather — partial failure ----

    blocTest<WeatherCubit, WeatherState>(
      'loadAllWeather emits success with partial locations when some city API calls fail',
      setUp: () {
        // Norwich, Glasgow, Cardiff — these will fail
        final failingCities = [
          CityType.norwich,
          CityType.glasgow,
          CityType.cardiff,
        ];

        // London and Cambridge — these will succeed
        final successfulCities = [CityType.london, CityType.cambridge];

        // Stub failing cities: getWeather throws
        for (final cityType in failingCities) {
          when(
            () => repositoryMock.getWeather(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => throw Exception('API error'));

          when(
            () => repositoryMock.getForecast(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => throw Exception('API error'));
        }

        // Stub successful cities: getWeather returns data
        for (final cityType in successfulCities) {
          when(
            () => repositoryMock.getWeather(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeWeather());

          when(
            () => repositoryMock.getForecast(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeForecast(8));
        }
      },
      build: () => WeatherCubit(repositoryMock),
      act: (cubit) async {
        await cubit.loadAllWeather();
      },
      expect: () => [isA<WeatherStateSuccess>()],
      verify: (cubit) {
        final successState = cubit.state as WeatherStateSuccess;
        // Only 2 cities should succeed (London and Cambridge)
        expect(successState.locations.length, 2);
        final cityTypes =
            successState.locations.map((loc) => loc.cityType).toList();
        expect(cityTypes, contains(CityType.london));
        expect(cityTypes, contains(CityType.cambridge));
      },
    );

    // ---- loadAllWeather — complete failure (all cities fail) ----

    blocTest<WeatherCubit, WeatherState>(
      'loadAllWeather emits success with zero locations when all city API calls fail',
      setUp: () {
        // Make all cities fail
        for (final cityType in CityType.values) {
          when(
            () => repositoryMock.getWeather(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => throw Exception('API error'));

          when(
            () => repositoryMock.getForecast(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => throw Exception('API error'));
        }
      },
      build: () => WeatherCubit(repositoryMock),
      act: (cubit) async {
        await cubit.loadAllWeather();
      },
      expect: () => [isA<WeatherStateSuccess>()],
      verify: (cubit) {
        final successState = cubit.state as WeatherStateSuccess;
        // All cities fail silently, so we get 0 locations
        expect(successState.locations.length, 0);
      },
    );

    // ---- loadAllWeather — data sorting ----

    blocTest<WeatherCubit, WeatherState>(
      'loadAllWeather emits success with forecast sorted by dateTime',
      setUp: () {
        for (final cityType in CityType.values) {
          when(
            () => repositoryMock.getWeather(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeWeather());

          // Return forecast in reverse chronological order
          final reverseForecast = _makeForecast(8).reversed.toList();
          when(
            () => repositoryMock.getForecast(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => reverseForecast);
        }
      },
      build: () => WeatherCubit(repositoryMock),
      act: (cubit) async {
        await cubit.loadAllWeather();
      },
      expect: () => [isA<WeatherStateSuccess>()],
      verify: (cubit) {
        final successState = cubit.state as WeatherStateSuccess;
        for (final location in successState.locations) {
          // Verify forecast is sorted by dateTime ascending
          for (int i = 0; i < location.forecast.length - 1; i++) {
            expect(
              location.forecast[i].dateTime.isBefore(
                location.forecast[i + 1].dateTime,
              ),
              isTrue,
              reason:
                  'Forecast entries should be sorted by dateTime ascending',
            );
          }
        }
      },
    );

    // ---- toggleUnitType ----

    blocTest<WeatherCubit, WeatherState>(
      'toggleUnitType cycles between metric and imperial',
      setUp: () {
        for (final cityType in CityType.values) {
          when(
            () => repositoryMock.getWeather(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeWeather());

          when(
            () => repositoryMock.getForecast(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeForecast(8));
        }
      },
      build: () => WeatherCubit(repositoryMock),
      act: (cubit) async {
        await cubit.loadAllWeather();
        cubit.toggleUnitType();
        cubit.toggleUnitType();
        cubit.toggleUnitType();
      },
      expect: () => [
        isA<WeatherStateSuccess>(),
        isA<WeatherStateSuccess>(),
        isA<WeatherStateSuccess>(),
        isA<WeatherStateSuccess>(),
      ],
      verify: (cubit) {
        // After 3 toggles: metric -> imperial -> metric -> imperial
        expect(cubit.state.unitType, UnitType.imperial);
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'toggleUnitType with cached locations preserves location count',
      setUp: () {
        for (final cityType in CityType.values) {
          when(
            () => repositoryMock.getWeather(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeWeather());

          when(
            () => repositoryMock.getForecast(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeForecast(8));
        }
      },
      build: () => WeatherCubit(repositoryMock),
      act: (cubit) async {
        await cubit.loadAllWeather();
        cubit.toggleUnitType();
      },
      expect: () => [
        isA<WeatherStateSuccess>(),
        isA<WeatherStateSuccess>(),
      ],
      verify: (cubit) {
        final successState = cubit.state as WeatherStateSuccess;
        expect(successState.locations.length, CityType.values.length);
        expect(successState.unitType, UnitType.imperial);
      },
    );

    // ---- Combined: loadAllWeather with unit type switching ----

    blocTest<WeatherCubit, WeatherState>(
      'loadAllWeather then toggleUnitType preserves location data with updated unitType',
      setUp: () {
        for (final cityType in CityType.values) {
          when(
            () => repositoryMock.getWeather(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeWeather());

          when(
            () => repositoryMock.getForecast(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeForecast(8));
        }
      },
      build: () => WeatherCubit(repositoryMock),
      act: (cubit) async {
        await cubit.loadAllWeather();
        cubit.toggleUnitType();
      },
      expect: () => [
        isA<WeatherStateSuccess>(),
        isA<WeatherStateSuccess>(),
      ],
      verify: (cubit) {
        final successState = cubit.state as WeatherStateSuccess;
        expect(successState.unitType, UnitType.imperial);
        expect(successState.locations.length, CityType.values.length);
        // Verify all locations still exist after toggle
        for (final cityType in CityType.values) {
          expect(
            successState.locations.any((loc) => loc.cityType == cityType),
            isTrue,
          );
        }
      },
    );

    // ---- Multiple loadAllWeather calls ----

    blocTest<WeatherCubit, WeatherState>(
      'Multiple loadAllWeather calls clear previous locations',
      setUp: () {
        for (final cityType in CityType.values) {
          when(
            () => repositoryMock.getWeather(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeWeather());

          when(
            () => repositoryMock.getForecast(
              lat: cityType.coordinate.lat,
              lon: cityType.coordinate.lon,
              unit: UnitType.metric.name,
            ),
          ).thenAnswer((_) async => _makeForecast(8));
        }
      },
      build: () => WeatherCubit(repositoryMock),
      act: (cubit) async {
        await cubit.loadAllWeather();
        await cubit.loadAllWeather();
      },
      expect: () => [
        isA<WeatherStateSuccess>(),
        isA<WeatherStateSuccess>(),
      ],
      verify: (cubit) {
        final successState = cubit.state as WeatherStateSuccess;
        expect(successState.locations.length, CityType.values.length);
      },
    );
  });
}
