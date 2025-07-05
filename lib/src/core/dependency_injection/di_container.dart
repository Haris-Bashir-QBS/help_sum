part of 'di_barrel.dart';

final sl = GetIt.instance;

Future<void> initializeDI() async {
  await LocalStorageService().init();
  await _initCoreDependencies();
  await _initAuthDependencies();
  await _initCategoryDependencies();
}

/// ------------------------
/// Core DEPENDENCIES
/// ------------------------

Future<void> _initCoreDependencies() async {
  sl
  // ..registerFactory(() => ThemeCubit())
  .registerLazySingleton(() => DioClient());
}

/// ------------------------
/// AUTH DEPENDENCIES
/// ------------------------

Future<void> _initAuthDependencies() async {
  // sl.registerLazySingleton(() => UserProvider());
  _registerAuthRemoteDatasources();
  _registerAuthRepositories();
  _registerAuthUsecases();

  // _registerAuthBloc();
}

void _registerAuthRemoteDatasources() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImplementation(client: sl()),
  );
}

void _registerAuthRepositories() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImplementation(remoteDataSource: sl()),
  );
}

void _registerAuthUsecases() {
  sl
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => SignupUseCase(sl()))
    ..registerLazySingleton(() => ResendOtpUsecase(sl()))
    ..registerLazySingleton(() => OtpUseCase(sl()));
  // ..registerLazySingleton(() => VerifyOtpUseCase(sl()))
  // ..registerLazySingleton(() => ChangePasswordUsecase(sl()))
  // ..registerLazySingleton(() => ForgetPasswordUsecase(sl()))
  // ..registerLazySingleton(() => LogoutUseCase(sl()))
  // ..registerLazySingleton(() => ResetPasswordUsecase(sl()));
}

/// ------------------------
/// CATEGORY DEPENDENCIES
/// ------------------------

Future<void> _initCategoryDependencies() async {
  _registerCategoryRemoteDatasources();
  _registerCategoryRepositories();
  _registerCategoryUsecases();
}

void _registerCategoryRemoteDatasources() {
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(client: sl()),
  );
}

void _registerCategoryRepositories() {
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl()),
  );
}

void _registerCategoryUsecases() {
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
}


