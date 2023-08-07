import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppBlocObserver implements BlocObserver {
  AppBlocObserver();

  @override
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    if (!kReleaseMode) {
      print(error);
    }

    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  @override
  void onChange(BlocBase cubit, Change change) {
    print('--> ${change.nextState.toString()}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    print(event.toString());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {}

  @override
  void onClose(BlocBase cubit) {}

  @override
  void onCreate(BlocBase cubit) {}
}
