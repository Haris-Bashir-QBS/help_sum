part of 'di_barrel.dart';

final sl = GetIt.instance;

Future<void> initializeDI() async {
  await LocalStorageService().init();
  await _initCoreDependencies();
  await _initAuthDependencies();
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
    ..registerLazySingleton(() => OtpUseCase(sl()));
  // ..registerLazySingleton(() => VerifyOtpUseCase(sl()))
  // ..registerLazySingleton(() => ChangePasswordUsecase(sl()))
  // ..registerLazySingleton(() => ForgetPasswordUsecase(sl()))
  // ..registerLazySingleton(() => LogoutUseCase(sl()))
  // ..registerLazySingleton(() => ResetPasswordUsecase(sl()));
}

// void _registerAuthBloc() {
//   sl.registerFactory(
//     () => AuthBloc(
//       loginUseCase: sl(),
//       logoutUseCase: sl(),
//       userCubit: sl(),
//       verifyOptUseCase: sl(),
//       changePasswordUseCase: sl(),
//       forgetPasswordUsecase: sl(),
//       resetPasswordUsecase: sl(),
//     ),
//   );
