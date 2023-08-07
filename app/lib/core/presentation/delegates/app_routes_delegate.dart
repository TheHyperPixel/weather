import 'package:app/core/presentation/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/presentation/screens/main_screen.dart';
import 'package:app/core/presentation/screens/sync_screen.dart';

class AppRoutesDelegate {
  static const String main = '/';
  static const String detail = '/detail';

  static MaterialPageRoute getAppRoutes(RouteSettings settings) {
    WidgetBuilder builder;

    switch (settings.name) {
      case AppRoutesDelegate.main:
        builder = (BuildContext _) => const MainScreen();
        break;
      case AppRoutesDelegate.detail:
        builder = (BuildContext _) => const DetailScreen();
        break;
      default:
        builder = (BuildContext _) => SyncScreen();
        break;
    }

    return MaterialPageRoute(builder: builder, settings: settings);
  }
}
