part of 'di_barrel.dart';

final sl = GetIt.instance;

Future<void> initializeDI() async {
  await LocalStorageService().init();
  await _initCoreDependencies();
  await _initAuthDependencies();
  await _initCategoryDependencies();
  await _initPaymentDependencies();
  await _initBookingDependencies();
  await _initMerchantViewProfileDependencies();
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
    ..registerLazySingleton(() => OtpUseCase(sl()))
    ..registerLazySingleton(() => UpdateUserProfileUsecase(sl()))
    ..registerLazySingleton(() => UploadFileUseCase(sl()))
    ..registerLazySingleton(() => FetchMerchantSetupDetails(sl()))
    ..registerLazySingleton(() => GetGroupedServicesUseCase(sl()));
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
  sl
    ..registerLazySingleton(() => GetCategoriesUseCase(sl()))
    ..registerLazySingleton(() => GetServicesByCategoryUseCase(sl()))
    ..registerLazySingleton(() => GetNearbyMerchantsUseCase(sl()));
}

/// ------------------------
/// PAYMENT DEPENDENCIES
/// ------------------------

Future<void> _initPaymentDependencies() async {
  _registerPaymentRemoteDatasources();
  _registerPaymentRepositories();
  _registerPaymentUsecases();
}

void _registerPaymentRemoteDatasources() {
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImplementation(client: sl()),
  );
}

void _registerPaymentRepositories() {
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImplementation(remoteDataSource: sl()),
  );
}

void _registerPaymentUsecases() {
  sl
    ..registerLazySingleton(() => AddCardUseCase(sl()))
    ..registerLazySingleton(() => GetCardsUseCase(sl()))
    ..registerLazySingleton(() => DeleteCardUseCase(sl()))
    ..registerLazySingleton(() => SetDefaultCardUseCase(sl()));
}

Future<void> _initBookingDependencies() async {
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<MerchantJobsRemoteSource>(
    () => MerchantJobsRemoteSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MerchantJobsRepository>(
    () => MerchantJobsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CreateJobUseCase(sl()));
  sl.registerLazySingleton(() => FetchJobsByTypeUseCase(sl()));
  sl.registerLazySingleton(() => GetAllJobsByTypeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateJobStatusMerchantUseCase(sl()));
}

Future<void> _initMerchantViewProfileDependencies() async {
  sl.registerLazySingleton<MerchantViewProfileRemoteDatasource>(
    () => MerchantViewProfileRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<MerchantViewProfileRepository>(
    () => MerchantViewProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetMerchantViewProfileUseCase(sl()));
}
