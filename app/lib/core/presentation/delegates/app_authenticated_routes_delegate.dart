import 'package:flutter/material.dart';
import 'package:app/features/master/presentation/screen/master_screen.dart';
import 'package:app/features/sync/presentation/screen/sync_screen.dart';

class AppAuthenticatedRoutesDelegate {
  static const String root = '/';

  static MaterialPageRoute getAppRoutes(RouteSettings settings) {
    WidgetBuilder builder;

    switch (settings.name) {
      case AppAuthenticatedRoutesDelegate.root:
        builder = (BuildContext _) => const MasterScreen();
        break;

      default:
        builder = (BuildContext _) => SyncScreen();
        break;
    }

    return MaterialPageRoute(builder: builder, settings: settings);
  }
}
