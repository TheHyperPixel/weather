import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/presentation/delegates/app_delegate.dart';
import 'package:app/core/domain/observer/app_bloc_observer.dart';
import 'package:app/injector.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await configureAppDependencies();

    Bloc.observer = getIt<AppBlocObserver>();

    runApp(const AppDelegate());
  }, (exception, stack, {context}) {
    if (!kReleaseMode) {
      print(exception);
    }
  });
}
