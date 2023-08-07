import 'dart:isolate';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void setupCrashReporting() {
  if (!kIsWeb) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  }

  FlutterError.onError = (details) {
    if (!kReleaseMode) {
      print(details);
    }

    FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  if (!kIsWeb) {
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;

      if (!kReleaseMode) {
        print(errorAndStacktrace.first);
      }

      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);
  }
}
