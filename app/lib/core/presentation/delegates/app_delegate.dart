import 'package:app/core/domain/logic/cubit/weather_cubit.dart';
import 'package:app/core/presentation/delegates/app_routes_delegate.dart';
import 'package:app/core/presentation/styles/app_colors_scheme_base.dart';
import 'package:app/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/core/presentation/localizations/app_localizations.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:app/core/presentation/styles/app_colors_scheme_light.dart';
import 'package:provider/provider.dart';

RouteObserver authenticatedRouteObserver = RouteObserver();

RouteObserver unauthenticatedRouteObserver = RouteObserver();

class AppDelegate extends StatefulWidget {
  const AppDelegate({Key? key}) : super(key: key);

  @override
  _AppDelegateState createState() => _AppDelegateState();
}

class _AppDelegateState extends State<AppDelegate> {
  late GlobalKey<NavigatorState> _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: unauthenticatedRouteObserver),
        BlocProvider(
          create: (context) => getIt<WeatherCubit>()..loadAllWeather(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) {
          return AppLocalizations.of(context).appName;
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        theme: ThemeData(
          fontFamily: 'Outfit',
          primarySwatch: Colors.blueGrey,
        ),
        builder: (context, child) {
          return AppColorsDelegate(
            appColorsScheme: const AppColorsSchemeLight(),
            child: child!,
          );
        },
        home: Builder(
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
                    authenticatedRouteObserver,
                  ],
                  initialRoute: AppRoutesDelegate.main,
                  onGenerateRoute: AppRoutesDelegate.getAppRoutes,
                  onGenerateInitialRoutes: (navigator, initialRoute) {
                    return [
                      AppRoutesDelegate.getAppRoutes(
                        RouteSettings(name: initialRoute),
                      )
                    ];
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
