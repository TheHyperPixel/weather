part of 'map_cubit.dart';

abstract class MapState extends Equatable {}

class MapStateInitial extends MapState {
  @override
  List<Object?> get props => [];
}

class MapStateSuccess extends MapState {
  final Coordinate coordinate;
  final MapType mapType;
  final MapTileType mapTileType;

  MapStateSuccess({
    required this.coordinate,
    required this.mapType,
    required this.mapTileType,
  });

  @override
  List<Object?> get props => [
        this.coordinate,
        this.mapType,
        this.mapTileType,
      ];
}

class MapStateError extends MapState {
  @override
  List<Object?> get props => [];
}

class MapStateFailure extends MapState {
  @override
  List<Object?> get props => [];
}
