import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:app/injector.config.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureAppDependencies() => getIt.init();

@module
abstract class RegisterModule {
  // @singleton
  // FirebaseAnalytics get firebaseAnalytics =>
  //     FirebaseAnalytics.instance..setAnalyticsCollectionEnabled(kReleaseMode);

  // @singleton
  // FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  // @singleton
  // FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // @singleton
  // FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  // @singleton
  // FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  // @factory
  // ApiClient get apiClient => tapdatCoreGetIt<ApiClient>(
  //       param1: 'a', //Constants.appApiBase,
  //       param2: 'b', //Constants.appApiRoot,
  //     );
}
