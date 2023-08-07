import 'package:app/core/data/client/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:app/injector.config.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureAppDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @singleton
  ApiClient get apiClient => ApiClient();
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
