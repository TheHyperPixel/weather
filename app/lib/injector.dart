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
  @injectable
  ApiClient get apiClient => ApiClient();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}
