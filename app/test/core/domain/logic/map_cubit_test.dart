import 'package:app/core/domain/entities/coordinate.dart';
import 'package:app/core/domain/enums/map_tile_type.dart';
import 'package:app/core/domain/logic/map/map_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  Coordinate _testCoordinate = const Coordinate(lat: 0, lon: 0);
  group('$MapCubit', () {
    test('First state of MapCubit is Initial', () {
      final cubit = MapCubit();
      expect(cubit.state, MapStateInitial());
    });

    blocTest(
      'First state emitted after initial and loadMap called emits specific mapType and mapTileType with the coordinate',
      build: () => MapCubit(),
      act: (cubit) {
        cubit.loadMap(coordinate: _testCoordinate);
      },
      expect: () => [
        MapStateSuccess(
          coordinate: _testCoordinate,
          mapType: MapType.normal,
          mapTileType: MapTileType.temperature,
        ),
      ],
    );

    blocTest(
      'Toggle Map Type changes MapType',
      build: () => MapCubit(),
      act: (cubit) {
        cubit.loadMap(coordinate: _testCoordinate);
        cubit.toggleMapType();
      },
      expect: () => [
        MapStateSuccess(
          coordinate: _testCoordinate,
          mapType: MapType.normal,
          mapTileType: MapTileType.temperature,
        ),
        MapStateSuccess(
          coordinate: _testCoordinate,
          mapType: MapType.satellite,
          mapTileType: MapTileType.temperature,
        ),
      ],
    );

    blocTest(
      'Changing Map Tile Type changes MapTileType',
      build: () => MapCubit(),
      act: (cubit) {
        cubit.loadMap(coordinate: _testCoordinate);
        cubit.changeMapTileType(mapTileType: MapTileType.clouds);
        cubit.changeMapTileType(mapTileType: MapTileType.precipitation);
        cubit.changeMapTileType(mapTileType: MapTileType.pressure);
        cubit.changeMapTileType(mapTileType: MapTileType.temperature);
        cubit.changeMapTileType(mapTileType: MapTileType.wind);
      },
      expect: () => [
        MapStateSuccess(
          coordinate: _testCoordinate,
          mapType: MapType.normal,
          mapTileType: MapTileType.temperature,
        ),
        MapStateSuccess(
          coordinate: _testCoordinate,
          mapType: MapType.normal,
          mapTileType: MapTileType.clouds,
        ),
        MapStateSuccess(
          coordinate: _testCoordinate,
          mapType: MapType.normal,
          mapTileType: MapTileType.precipitation,
        ),
        MapStateSuccess(
          coordinate: _testCoordinate,
          mapType: MapType.normal,
          mapTileType: MapTileType.pressure,
        ),
        MapStateSuccess(
          coordinate: _testCoordinate,
          mapType: MapType.normal,
          mapTileType: MapTileType.temperature,
        ),
        MapStateSuccess(
          coordinate: _testCoordinate,
          mapType: MapType.normal,
          mapTileType: MapTileType.wind,
        ),
      ],
    );
  });
}
