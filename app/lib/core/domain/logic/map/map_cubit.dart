import 'package:app/core/domain/entities/coordinate.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

part 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapStateInitial());

  late Coordinate _coordinate;

  loadMap({required Coordinate coordinate}) {
    try {
      this._coordinate = coordinate;
      this._emitSuccess();
    } catch (e) {
      emit(MapStateFailure());
    }
  }

  _emitSuccess() {
    emit(
      MapStateSuccess(
        coordinate: this._coordinate,
      ),
    );
  }
}
