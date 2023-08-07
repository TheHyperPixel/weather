part of 'map_cubit.dart';

abstract class MapState {}

class MapStateInitial extends MapState {}

class MapStateSuccess extends MapState {
  final Coordinate coordinate;

  MapStateSuccess({required this.coordinate});
}

class MapStateError extends MapState {}

class MapStateFailure extends MapState {}
