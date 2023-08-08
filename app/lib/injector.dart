import 'package:app/core/data/client/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:app/injector.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureAppDependencies() async => getIt.init();

@module
abstract class RegisterModule {
  @injectable
  ApiClient get apiClient => ApiClient();
}
