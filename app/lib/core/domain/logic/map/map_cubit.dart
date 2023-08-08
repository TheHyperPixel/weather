import 'package:app/core/domain/entities/coordinate.dart';
import 'package:app/core/domain/enums/map_tile_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

part 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapStateInitial());

  late Coordinate _coordinate;
  MapType _mapType = MapType.normal;
  MapTileType _mapTileType = MapTileType.temperature;

  loadMap({required Coordinate coordinate}) {
    try {
      this._coordinate = coordinate;
      emit(
        MapStateSuccess(
          coordinate: this._coordinate,
          mapType: this._mapType,
          mapTileType: this._mapTileType,
        ),
      );
    } catch (e) {
      emit(MapStateFailure());
    }
  }

  toggleMapType() {
    try {
      if (this._mapType == MapType.normal) {
        _mapType = MapType.satellite;
      } else {
        _mapType = MapType.normal;
      }
      emit(
        MapStateSuccess(
          coordinate: this._coordinate,
          mapType: this._mapType,
          mapTileType: this._mapTileType,
        ),
      );
    } catch (e) {
      emit(MapStateError());
    }
  }

  changeMapTileType({required MapTileType mapTileType}) {
    try {
      this._mapTileType = mapTileType;
      emit(
        MapStateSuccess(
          coordinate: this._coordinate,
          mapType: this._mapType,
          mapTileType: this._mapTileType,
        ),
      );
    } catch (e) {
      emit(MapStateError());
    }
  }
}
