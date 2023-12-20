import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher/features/on_boarding/data/datasource/on_boarding_local_data_source.dart';
import 'package:teacher/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:teacher/features/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:teacher/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:teacher/features/on_boarding/domain/usecases/is_user_is_first_timer.dart';
import 'package:teacher/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  //feature --> OnBoarding
  //Business Logic
  sl
    ..registerFactory(
      () => OnBoardingCubit(cacheFirstTimer: sl(), isUserFirstTimer: sl()),
    )
    ..registerLazySingleton(() => CacheFirstTimer(repository: sl()))
    ..registerLazySingleton(() => IsUserIsFirstTimer(repository: sl()))
    ..registerLazySingleton<OnBoardingRepository>(
      () => OnBoardingRepositoryImpl(
        localDataSource: sl(),
      ),
    )
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSourceImpl(sharedPreference: sl()),
    )
    ..registerLazySingleton(() => prefs);
}
