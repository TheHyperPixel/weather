import 'package:flutter/material.dart';
import 'package:app/core/presentation/screens/main_screen.dart';
import 'package:app/core/presentation/screens/sync_screen.dart';

class AppAuthenticatedRoutesDelegate {
  static const String root = '/';

  static MaterialPageRoute getAppRoutes(RouteSettings settings) {
    WidgetBuilder builder;

    switch (settings.name) {
      case AppAuthenticatedRoutesDelegate.root:
        builder = (BuildContext _) => const MainScreen();
        break;

      default:
        builder = (BuildContext _) => SyncScreen();
        break;
    }

    return MaterialPageRoute(builder: builder, settings: settings);
  }
}
