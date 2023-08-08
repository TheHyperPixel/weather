import 'dart:isolate';

import 'package:flutter/foundation.dart';

void setupCrashReporting() {
  FlutterError.onError = (details) {
    if (!kReleaseMode) {
      print(details);
    }
  };

  if (!kIsWeb) {
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;

      if (!kReleaseMode) {
        print(errorAndStacktrace.first);
      }
    }).sendPort);
  }
}
