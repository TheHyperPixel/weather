import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:app/core/presentation/delegates/app_authenticated_delegate.dart';
import 'package:app/core/presentation/delegates/app_unauthenticated_delegate.dart';
import 'package:app/core/presentation/localizations/app_localizations.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:app/core/presentation/styles/app_colors_scheme_light.dart';
import 'package:app/core/presentation/screens/sync_screen.dart';
import 'package:app/injector.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

RouteObserver authenticatedRouteObserver = RouteObserver();

RouteObserver unauthenticatedRouteObserver = RouteObserver();

class AppDelegate extends StatefulWidget {
  const AppDelegate({Key? key}) : super(key: key);

  @override
  _AppDelegateState createState() => _AppDelegateState();
}

class _AppDelegateState extends State<AppDelegate> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: unauthenticatedRouteObserver),
        // BlocProvider(
        //   create: (context) =>
        //       getIt<AuthBloc>()..add(AuthEventLoginStatusRequested()),
        // ),
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
            return SyncScreen();
            // return BlocConsumer<AuthBloc, AuthState>(
            //   listener: (context, state) {
            //     if (state is AuthStateLoginSuccess) {
            //       FirebaseCrashlytics.instance
            //           .setUserIdentifier(state.userAuth.uuid);
            //     }
            //   },
            //   builder: (context, state) {
            //     if (state is AuthStateLoginSuccess) {
            //       return const AppAuthenticatedDelegate();
            //     } else if (state is AuthStateLoginStatusCheckInProgress ||
            //         state is AuthStateInitial) {
            //       return SyncScreen();
            //     } else {
            //       return const AppUnauthenticatedDelegate();
            //     }
            //   },
            // );
          },
        ),
      ),
    );
  }
}
