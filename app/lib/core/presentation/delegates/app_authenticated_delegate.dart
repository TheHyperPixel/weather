import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:app/core/presentation/delegates/app_authenticated_routes_delegate.dart';
import 'package:app/core/presentation/delegates/app_delegate.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:app/core/presentation/styles/app_colors_scheme_base.dart';
import 'package:app/core/presentation/styles/app_colors_scheme_light.dart';
import 'package:app/injector.dart';
import 'package:provider/provider.dart';

class AppAuthenticatedDelegate extends StatefulWidget {
  const AppAuthenticatedDelegate({Key? key}) : super(key: key);

  @override
  _AppAuthenticatedDelegateState createState() =>
      _AppAuthenticatedDelegateState();
}

class _AppAuthenticatedDelegateState extends State<AppAuthenticatedDelegate> {
  late GlobalKey<NavigatorState> _navigatorKey;

  late HeroController _heroController;

  @override
  void initState() {
    super.initState();

    this._navigatorKey = GlobalKey();
    _heroController = HeroController(createRectTween: _createRectTween);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: authenticatedRouteObserver),
        // BlocProvider<RemoteConfigBloc>(
        //   create: (_) => getIt<RemoteConfigBloc>()
        //     ..add(
        //       RemoteConfigEventLoadRequested(),
        //     ),
        //   lazy: false,
        // ),
      ],
      child: Builder(
        builder: (context) {
          AppColorsSchemeBase _colorScheme = const AppColorsSchemeLight();

          return AppColorsDelegate(
            appColorsScheme: _colorScheme,
            child: WillPopScope(
              onWillPop: () async {
                if (this._navigatorKey.currentState!.canPop()) {
                  this._navigatorKey.currentState!.pop();
                  return false;
                } else {
                  return true;
                }
              },
              child: Navigator(
                key: this._navigatorKey,
                observers: [
                  _heroController,
                  authenticatedRouteObserver,
                  FirebaseAnalyticsObserver(
                    analytics: getIt<FirebaseAnalytics>(),
                    nameExtractor: (settings) {
                      return '/authenticated${(settings.name ?? '/unknown')}';
                    },
                  ),
                ],
                initialRoute: AppAuthenticatedRoutesDelegate.root,
                onGenerateRoute: AppAuthenticatedRoutesDelegate.getAppRoutes,
                onGenerateInitialRoutes: (navigator, initialRoute) {
                  return [
                    AppAuthenticatedRoutesDelegate.getAppRoutes(
                      RouteSettings(name: initialRoute),
                    )
                  ];
                },
              ),
            ),
          );
        },
      ),
    );
  }

  RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectArcTween(begin: begin, end: end);
  }
}
