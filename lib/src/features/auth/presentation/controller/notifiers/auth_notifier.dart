import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/resend_otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/grouped_category_entity.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/domain/usecases/fetch_merchant_setup_details.dart';
import 'package:help_sum/src/features/auth/domain/usecases/get_groupped_services_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/otp_use_case.dart';
import 'package:help_sum/src/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/signup_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/upload_file_usecase.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/common/profile/presentation/controller/user_state_provider.dart';
import 'auth_state.dart';
part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final LoginUseCase _loginUseCase = sl();
  late final SignupUseCase _signUpUseCase = sl();
  late final UploadFileUseCase _uploadFileUseCase = sl();
  late final OtpUseCase _otpUseCase = sl();
  late final ResendOtpUsecase _resendOtpUsecase = sl();
  late final GetGroupedServicesUseCase _getGroupedServicesUseCase = sl();
  late final FetchMerchantSetupDetails _fetchMerchantSetupDetails = sl();
  late final UpdateUserProfileUsecase _updateUserProfileUsecase = sl();

  // User entity
  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  List<GroupedCategoryEntity> _groppedServices = [];
  List<GroupedCategoryEntity> get groppedServices => _groppedServices;

  final List<ServiceEntity> _selectedServices = [];
  List<ServiceEntity> get selectedServices => _selectedServices;

  void addService(ServiceEntity service) {
    _selectedServices.add(service);
    //update the state
    state = ServicesSuccess(
      _groppedServices,
      selectedServices: _selectedServices,
    );
  }

  //delete service
  void removeService(ServiceEntity service) {
    _selectedServices.remove(service);
    //update the state
    state = ServicesSuccess(
      _groppedServices,
      selectedServices: _selectedServices,
    );
  }

  bool _isSearching = false;

  ///Getter
  bool get isSearching => _isSearching;

  ///Setter
  void updateSearch(bool isSearching) {
    _isSearching = isSearching;
    //update the state
    state = ServicesSuccess(
      _groppedServices,
      selectedServices: _selectedServices,
      filteredServices: _groppedServices,
      isSearching: isSearching,
    );
  }

  //filter services
  void filterServices(String query) {
    if (query.isEmpty) {
      state = ServicesSuccess(
        _groppedServices,
        selectedServices: _selectedServices,
        isSearching: _isSearching,
      );
      return;
    }

    // Filter the services based on the query not category
    final filteredServices =
        _groppedServices.map((category) {
          final filteredServices =
              category.services.where((service) {
                return service.name.toLowerCase().contains(query.toLowerCase());
              }).toList();
          return GroupedCategoryEntity(
            id: category.id,
            categoryName: category.categoryName,
            services: filteredServices,
          );
        }).toList();

    state = ServicesSuccess(
      filteredServices,
      selectedServices: _selectedServices,
      filteredServices: filteredServices,
      isSearching: _isSearching,
    );
  }

  @override
  AuthState build() => AuthInitial();

  Future<void> login(
    LoginRequestModel params, {
    required BuildContext context,
  }) async {
    state = LoginLoading();
    final result = await _loginUseCase(params);

    result.match((failure) => state = LoginError(failure.message), (
      userAndToken,
    ) async {
      final (user, token) = userAndToken;
      _currentUser = user;
      await LocalStorageService().saveAccessToken(token);
      await LocalStorageService().saveUser(UserModel.fromEntity(user));
      ref.read(currentUserProvider.notifier).setUser(user);
      state = LoginSuccess(user);
    });
  }

  Future<void> signup(SignUpRequestModel params) async {
    state = SignupLoading();
    final result = await _signUpUseCase(params);

    result.match(
      (failure) => state = SignupError(failure.message),
      (userId) => state = SignupSuccess(userId),
    );
  }

  Future<void> uploadFile(UploadFileRequest params) async {
    state = UploadingFileLoading();
    final result = await _uploadFileUseCase(params);

    result.match(
      (failure) => state = UploadingFileError(failure),
      (userId) => state = UploadingFileSuccess(userId),
    );
  }

  Future<void> verifyOtp(OtpRequestModel params) async {
    state = OtpLoading();
    final result = await _otpUseCase(params);

    result.match((failure) => state = OtpError(failure.message), (user) async {
      _currentUser = user;
      await LocalStorageService().saveUser(UserModel.fromEntity(user));
      ref.read(currentUserProvider.notifier).setUser(_currentUser!);
      state = OtpSuccess(user);
    });
  }

  Future<void> updateSkills(
    BuildContext context,
    UpdateProfileRequest params, {
    Function()? onSuccess,
  }) async {
    state = ServicesSuccess(
      _groppedServices,
      selectedServices: _selectedServices,
      savingSkills: true,
    );
    final result = await _updateUserProfileUsecase(params);
    state = ServicesSuccess(
      _groppedServices,
      selectedServices: _selectedServices,
      savingSkills: false,
    );
    result.match(
      (failure) {
        CustomToast.errorToast(context: context, message: failure.message);
      },
      (user) async {
        _currentUser = user;
        await LocalStorageService().saveUser(UserModel.fromEntity(user));
        ref.read(currentUserProvider.notifier).setUser(user);

        if (onSuccess != null) {
          onSuccess();
        }
      },
    );
  }

  Future<void> updateInfo(
    BuildContext context,
    UpdateProfileRequest params, {
    Function()? onSuccess,
  }) async {
    state = SaveBasicInfoLoading();
    final result = await _updateUserProfileUsecase(params);

    result.match(
      (failure) {
        state = SaveBasicInfoError(failure);
        CustomToast.errorToast(context: context, message: failure.message);
      },
      (user) async {
        _currentUser = user;
        await LocalStorageService().saveUser(UserModel.fromEntity(user));
        ref.read(currentUserProvider.notifier).setUser(user);
        state = SaveBasicInfoSuccess();
      },
    );
  }

  Future<void> updateLatLong(
    BuildContext context,
    UpdateProfileRequest params, {
    Function()? onSuccess,
  }) async {
    final result = await _updateUserProfileUsecase(params);

    result.match(
      (failure) {
        CustomToast.errorToast(context: context, message: failure.message);
      },
      (user) async {
        _currentUser = user;
        await LocalStorageService().saveUser(UserModel.fromEntity(user));
        ref.read(currentUserProvider.notifier).setUser(user);

        if (onSuccess != null) {
          onSuccess();
        }
      },
    );
  }

  Future<void> updateRate(
    BuildContext context,
    UpdateProfileRequest params,
  ) async {
    state = RatesLoading();
    final result = await _updateUserProfileUsecase(params);

    result.match(
      (failure) {
        state = RatesError();
        CustomToast.errorToast(context: context, message: failure.message);
      },
      (user) async {
        _currentUser = user;
        await LocalStorageService().saveUser(UserModel.fromEntity(user));
        ref.read(currentUserProvider.notifier).setUser(user);
        state = RatesSuccess();
      },
    );
  }

  Future<void> updatePortfolio(
    BuildContext context,
    UpdateProfileRequest params,
  ) async {
    state = SavePortfolioLoading();
    final result = await _updateUserProfileUsecase(params);

    result.match(
      (failure) {
        state = SavePortfolioError(failure);
        CustomToast.errorToast(context: context, message: failure.message);
      },
      (user) async {
        _currentUser = user;
        await LocalStorageService().saveUser(UserModel.fromEntity(user));
        ref.read(currentUserProvider.notifier).setUser(user);
        state = SavePortfolioSuccess();
      },
    );
  }

  Future<void> updateDescription(
    BuildContext context,
    UpdateProfileRequest params,
  ) async {
    state = DescriptionLoading();
    final result = await _updateUserProfileUsecase(params);

    result.match(
      (failure) {
        state = DescriptionError();
        CustomToast.errorToast(context: context, message: failure.message);
      },
      (user) async {
        _currentUser = user;
        await LocalStorageService().saveUser(UserModel.fromEntity(user));
        ref.read(currentUserProvider.notifier).setUser(user);
        state = DescriptionSuccess();
      },
    );
  }

  /// Fetch Stripe Account URL
  Future<String> fetchStripeAccount(BuildContext ctx) async {
    AppUtils.showLoadingDialog(
      context: ctx,
      message: "Fetching Merchant Setup Details...",
    );
    final result = await _fetchMerchantSetupDetails(NoParams());
    AppUtils.closeLoadingDialog(ctx);

    return result.match(
      (failure) {
        state = MerchantSetupError(failure);
        CustomToast.errorToast(context: ctx, message: failure.message);
        return '';
      },
      (entity) {
        if (entity.url != null) {
          state = MerchantSetupSuccess(entity);
        } else {
          UserEntity? user = ref.read(currentUserProvider).user;

          if (user != null) {
            final updatedUser = user.copyWith(isMerchant: true);
            ref.read(currentUserProvider.notifier).updateUser(updatedUser);
          }

          CustomToast.errorToast(context: ctx, message: entity.message ?? "");
        }

        return entity.url ?? '';
      },
    );
  }

  Future<void> updateSchdule(
    BuildContext context,
    UpdateProfileRequest params, {
    Function()? onSuccess,
  }) async {
    final result = await _updateUserProfileUsecase(params);
    result.match(
      (failure) {
        state = ScheduleError();
        CustomToast.errorToast(context: context, message: failure.message);
      },
      (user) async {
        _currentUser = user;
        _currentUser?.isCompleted = true;
        await LocalStorageService().saveUser(UserModel.fromEntity(user));
        ref.read(currentUserProvider.notifier).setUser(user);
        state = ScheduleSuccess();
        CustomToast.successToast(
          context: context,
          message: "Schedule updated successfully",
        );
        if (onSuccess != null) {
          onSuccess();
        }
      },
    );
  }

  Future<void> resendOtp(
    ResendOtpRequestModel params,
    Function(String message) onSuccess,
  ) async {
    state = ResendOtpLoading();
    final result = await _resendOtpUsecase(params);

    result.match((failure) => state = ResendOtpError(failure.message), (
      message,
    ) async {
      onSuccess(message);
      state = ResendOtpSuccess(message);
    });
  }

  Future<void> loadUserFromStorage() async {
    // await LocalStorageService().clearAll();
    final savedUserModel = LocalStorageService().user;
    Logger().d("Saved User Model: ${savedUserModel.toString()}");
    if (savedUserModel != null) {
      _currentUser = savedUserModel;
      ref.read(currentUserProvider.notifier).setUser(savedUserModel);
      log("Current User: ${_currentUser?.role.toString()}");
      state = LoginSuccess(_currentUser!);
    } else {
      state = AuthInitial();
    }
  }

  Future<void> getGrouppedServices() async {
    state = ServicesLoading();
    final result = await _getGroupedServicesUseCase(NoParams());

    result.match((failure) => state = ServicesError(failure.message), (
      data,
    ) async {
      _groppedServices = data;
      state = ServicesSuccess(_groppedServices);

      final userSelected = ref.read(currentUserProvider).user?.services;
      if (userSelected != null && userSelected.isNotEmpty) {
        // Add services to selectedServices where ids match
        final matchedServices =
            _groppedServices
                .expand((group) => group.services)
                .where(
                  (service) => userSelected.any((u) => u['_id'] == service.id),
                )
                .toList();
        _selectedServices.addAll(matchedServices);
      }
      state = ServicesSuccess(
        _groppedServices,
        selectedServices: _selectedServices,
      );
    });
  }

  void reset() => state = AuthInitial();
}
