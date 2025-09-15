part of 'di_barrel.dart';

final sl = GetIt.instance;

Future<void> initializeDI() async {
  await LocalStorageService().init();
  await _initCoreDependencies();
  await _initAuthDependencies();
  await _initCategoryDependencies();
  await _initPaymentDependencies();
  await _initWalletDependencies();
  await _initBookingDependencies();
  await _initMerchantViewProfileDependencies();
  await _initProfileDependencies();
  await _initChatDependencies();
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
  _registerAuthBloc();
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

void _registerAuthBloc() {
  sl.registerLazySingleton<LoginBloc>(() => LoginBloc());
  sl.registerFactory<SignupBloc>(() => SignupBloc());
  sl.registerFactory<VerifyOtpBloc>(() => VerifyOtpBloc());
  sl.registerFactory<SkillBloc>(() => SkillBloc());
  sl.registerFactory<ScheduleBloc>(() => ScheduleBloc());
  sl.registerFactory<PortfolioBloc>(() => PortfolioBloc());
  sl.registerFactory<ActivityBloc>(() => ActivityBloc());
  sl.registerFactory<CreateJobBloc>(() => CreateJobBloc());
  sl.registerFactory<RatingBloc>(() => RatingBloc());
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

Future<void> _initWalletDependencies() async {
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(sl()),
  );
  // Bridge interface to implementation
  sl.registerLazySingleton<WalletRepository>(
    () => _WalletRepositoryAdapter(sl()),
  );
  sl.registerFactory(() => GetWalletUseCase(sl()));
  sl.registerFactory(() => WalletBloc(getWalletUseCase: sl()));
}

void _registerPaymentRemoteDatasources() {
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImplementation(client: sl()),
  );
}

class _WalletRepositoryAdapter implements WalletRepository {
  final WalletRemoteDataSource remote;
  _WalletRepositoryAdapter(this.remote);
  @override
  Future<WalletEntity> getWallet() async {
    final WalletRepositoryImpl impl = WalletRepositoryImpl(remote);
    return impl.getWallet();
  }
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
    ..registerLazySingleton(() => SetDefaultCardUseCase(sl()))
    ..registerLazySingleton(() => PayForJobUseCase(sl()));
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
  sl.registerLazySingleton(() => StartJobUseCase(sl()));
  sl.registerLazySingleton(() => CompleteJobUseCase(sl()));
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

/// ------------------------
/// PROFILE DEPENDENCIES
/// ------------------------

Future<void> _initProfileDependencies() async {
  _registerProfileRemoteDatasources();
  _registerProfileRepositories();
  _registerProfileUsecases();
  _registerProfileBloc();
}

void _registerProfileRemoteDatasources() {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImplementation(client: sl()),
  );
}

void _registerProfileRepositories() {
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImplementation(remoteDataSource: sl()),
  );
}

void _registerProfileUsecases() {
  sl.registerLazySingleton<GetMerchantRatingsUseCase>(
    () => GetMerchantRatingsUseCase(profileRepository: sl()),
  );
  sl.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(profileRepository: sl()),
  );
}

void _registerProfileBloc() {
  sl.registerLazySingleton<ProfileBloc>(
    () => ProfileBloc(
      getMerchantRatingsUseCase: sl(),
      deleteAccountUseCase: sl(),
    ),
  );
}

// ================= Chat =================
void _registerChatServices() {
  sl.registerLazySingleton<SocketService>(() => SocketService());
}

void _registerChatRemoteDatasources() {
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      client: sl(),
      socketService: sl(),
    ),
  );
}

void _registerChatRepositories() {
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
}

void _registerChatUsecases() {
  sl.registerLazySingleton<GetInboxChatsUseCase>(
    () => GetInboxChatsUseCase(chatRepository: sl()),
  );
  sl.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(chatRepository: sl()),
  );
}

void _registerChatBloc() {
  sl.registerLazySingleton<ChatBloc>(
    () => ChatBloc(
      chatRepository: sl(),
      getInboxChatsUseCase: sl(),
      sendMessageUseCase: sl(),
    ),
  );
}

Future<void> _initChatDependencies() async {
  _registerChatServices();
  _registerChatRemoteDatasources();
  _registerChatRepositories();
  _registerChatUsecases();
  _registerChatBloc();
}
