part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initAuth();
}

Future<void> _initAuth() async {
  //feature --> Auth
  //Business Logic
  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
      ),
    )
    // usecases
    ..registerLazySingleton(() => SignIn(repository: sl()))
    ..registerLazySingleton(() => SignUp(repository: sl()))
    ..registerLazySingleton(() => ForgotPassword(repository: sl()))
    ..registerLazySingleton(() => UpdateUser(repository: sl()))

    // repositories
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: sl(),
      ),
    )

    // datasources
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )

    // others
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _initOnBoarding() async {
  final prefs = await SharedPreferences.getInstance();
  //feature --> OnBoarding
  //Business Logic
  sl
    ..registerFactory(
      () => OnBoardingCubit(cacheFirstTimer: sl(), isUserFirstTimer: sl()),
    )

    // usecases
    ..registerLazySingleton(() => CacheFirstTimer(repository: sl()))
    ..registerLazySingleton(() => IsUserIsFirstTimer(repository: sl()))

    // repositories
    ..registerLazySingleton<OnBoardingRepository>(
      () => OnBoardingRepositoryImpl(
        localDataSource: sl(),
      ),
    )

    // datasources
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSourceImpl(sharedPreference: sl()),
    )

    // others
    ..registerLazySingleton(() => prefs);
}
