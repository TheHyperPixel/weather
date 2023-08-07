import 'package:flutter/material.dart';
import 'package:app/features/sync/presentation/screen/sync_screen.dart';

class AppUnauthenticatedRoutesDelegate {
  static const String root = '/';
  // static const String onboarding = '/onboarding';
  // static const String signUpInPhoneNumber = '/signUpInPhoneNumber';
  // static const String signUpValidationText = '/signUpValidationText';
  // static const String signUpEmail = '/signUpEmail';
  // static const String signUpPassword = '/signUpPassword';
  // static const String signUpVerification = '/signUpVerification';
  // static const String signInEmail = '/signInEmail';
  // static const String forgottenPassword = 'forgottenPassword';

  static MaterialPageRoute getAppRoutes(RouteSettings settings) {
    WidgetBuilder builder;

    switch (settings.name) {
      case AppUnauthenticatedRoutesDelegate.root:
        builder = (BuildContext _) => SyncScreen();
        break;

      default:
        builder = (BuildContext _) => SyncScreen();
    }

    return MaterialPageRoute(builder: builder, settings: settings);
  }
}
