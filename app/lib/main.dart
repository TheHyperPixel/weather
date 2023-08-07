import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/presentation/delegates/app_delegate.dart';
import 'package:app/crash_reporting.dart';
import 'package:app/features/observer/domain/logic/bloc/app_bloc_observer.dart';
import 'package:app/injector.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // await Firebase.initializeApp(
    //   name: 'we-love-pets-app',
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    if (kIsWeb) {
      // FirebaseFirestore.instance.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
    } else {
      // FirebaseFirestore.instance.settings = const Settings(
      //   persistenceEnabled: true,
      //   cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      // );
    }
    // await FirebaseAppCheck.instance.activate();

    await configureAppDependencies();

    // setupCrashReporting();

    Bloc.observer = getIt<AppBlocObserver>();

    runApp(const AppDelegate());
  }, (exception, stack, {context}) {
    if (!kReleaseMode) {
      print(exception);
    }
    if (!kIsWeb) {
      // FirebaseCrashlytics.instance.recordError(exception, stack);
    }
  });
}
