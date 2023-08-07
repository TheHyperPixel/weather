import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:app/core/presentation/delegates/app_delegate.dart';
import 'package:app/core/presentation/delegates/app_unauthenticated_routes_delegate.dart';
import 'package:app/injector.dart';
import 'package:provider/provider.dart';

class AppUnauthenticatedDelegate extends StatefulWidget {
  const AppUnauthenticatedDelegate({Key? key}) : super(key: key);

  @override
  _AppUnauthenticatedDelegateState createState() =>
      _AppUnauthenticatedDelegateState();
}

class _AppUnauthenticatedDelegateState
    extends State<AppUnauthenticatedDelegate> {
  GlobalKey<NavigatorState>? _navigatorKey;

  @override
  void initState() {
    super.initState();

    this._navigatorKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: unauthenticatedRouteObserver),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (this._navigatorKey!.currentState!.canPop()) {
            this._navigatorKey!.currentState!.pop();

            return false;
          } else {
            return true;
          }
        },
        child: Navigator(
          key: this._navigatorKey,
          observers: [
            unauthenticatedRouteObserver,
            FirebaseAnalyticsObserver(
              analytics: getIt<FirebaseAnalytics>(),
              nameExtractor: (settings) => '/unauthenticated${settings.name!}',
            ),
          ],
          initialRoute: AppUnauthenticatedRoutesDelegate.root,
          onGenerateRoute: AppUnauthenticatedRoutesDelegate.getAppRoutes,
        ),
      ),
    );
  }
}
