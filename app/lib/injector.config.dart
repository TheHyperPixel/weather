// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app/core/data/client/api_client.dart' as _i3;
import 'package:app/core/data/repositories/open_weather_repository.dart' as _i6;
import 'package:app/core/domain/logic/map/map_cubit.dart' as _i7;
import 'package:app/core/domain/logic/weather/weather_cubit.dart' as _i9;
import 'package:app/core/domain/observer/app_bloc_observer.dart' as _i4;
import 'package:app/core/domain/repositories/i_weather_repository.dart' as _i5;
import 'package:app/injector.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:package_info_plus/package_info_plus.dart' as _i8;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.ApiClient>(() => registerModule.apiClient);
    gh.factory<_i4.AppBlocObserver>(() => _i4.AppBlocObserver());
    gh.factory<_i5.IWeatherRepository>(
        () => _i6.OpenWeatherRepository(gh<_i3.ApiClient>()));
    gh.factory<_i7.MapCubit>(() => _i7.MapCubit());
    await gh.factoryAsync<_i8.PackageInfo>(
      () => registerModule.packageInfo,
      preResolve: true,
    );
    gh.factory<_i9.WeatherCubit>(
        () => _i9.WeatherCubit(gh<_i5.IWeatherRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i10.RegisterModule {}
