import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/merchant_setup_respose_entitiy.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/domain/usecases/fetch_merchant_setup_details.dart';
import 'package:help_sum/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/upload_file_usecase.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/custom_overlay_loader.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final LoginUseCase _loginUseCase = sl();
  final LocalStorageService _localStorageService = LocalStorageService();
  late final FetchMerchantSetupDetails _fetchMerchantSetupDetails = sl();
  late final UploadFileUseCase _uploadFileUseCase = sl();
  late final UpdateUserProfileUsecase _profileUsecase = sl();

  LoginBloc() : super(LoginState()) {
    on<LoginUser>(_onLoginUSer);
    on<UpdateUser>(_onUpdateuser);
    on<CheckUserLoggedIn>(_onCheckUserLoggedIn);
    on<LogoutUser>(_onLogoutUser);
    on<FetchMerchantAccount>(_onFetchMerchantAccount);
    //New
    on<UpdateHourlyRateEvent>(_onHourlyRateChanged);
    on<UpdateDescriptionEvent>(_onDescriptionChanged);
    on<UpdateProfileImageEvent>(_updateProfileImage);
    on<UpdateCurrentUserEvent>(_updateCurrentUser);
  }

  FutureOr<void> _onUpdatePortfolioEvent(event, emit) async {
    final currentUser = state.userEntity;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(media: event.images);
      LocalStorageService().saveUser(UserModel.fromEntity(updatedUser));
      emit(state.copyWith(userEntity: updatedUser));
    }
  }

  FutureOr<void> _onFetchMerchantAccount(event, emit) async {
    CustomOverlayLoader.show(
      event.context,
      message: "Please wait we are fetching merchant account details...",
    );
    final result = await _fetchMerchantSetupDetails(NoParams());
    CustomOverlayLoader.hide();
    result.fold(
      (failure) {
        CustomToast.errorToast(
          context: event.context,
          message: state.apiErrorMessage,
        );
      },
      (data) {
        emit(state.copyWith(merchantSetupResposeEntitiy: data));
      },
    );
  }

  FutureOr<void> _onLogoutUser(event, emit) async {
    await _localStorageService.clearAll();
    emit(state.copyWith(userEntity: null, clearUser: true));
  }

  FutureOr<void> _onCheckUserLoggedIn(event, emit) async {
    final user = _localStorageService.user;
    if (user != null) {
      emit(state.copyWith(userEntity: user));
    } else {
      emit(state.copyWith(clearUser: true));
    }
  }

  FutureOr<void> _onUpdateuser(event, emit) async {
    emit(state.copyWith(userEntity: event.userEntity));
    await _localStorageService.saveUser(UserModel.fromEntity(event.userEntity));
  }

  FutureOr<void> _onLoginUSer(event, emit) async {
    emit(state.copyWith(isLoading: true, apiErrorMessage: ''));

    final result = await _loginUseCase(
      LoginRequestModel(
        phoneNumber: event.phoneNumber,
        password: event.password,
      ),
    );
    await result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, apiErrorMessage: error.message));
      },
      (success) async {
        final (user, token) = success;
        await _localStorageService.saveAccessToken(token);
        await _localStorageService.saveUser(UserModel.fromEntity(user));

        emit(
          state.copyWith(
            isLoading: false,
            apiErrorMessage: '',
            userEntity: user,
          ),
        );
      },
    );
  }

  FutureOr<void> _onHourlyRateChanged(event, emit) async {
    final currentUser = state.userEntity;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        hourlyRate: int.tryParse(event.newRate.toString()),
      );
      LocalStorageService().saveUser(UserModel.fromEntity(updatedUser));
      emit(state.copyWith(userEntity: updatedUser));
    }
  }

  FutureOr<void> _onDescriptionChanged(
    UpdateDescriptionEvent event,
    emit,
  ) async {
    final currentUser = state.userEntity;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        description: event.newDescription,
      );
      LocalStorageService().saveUser(UserModel.fromEntity(updatedUser));
      emit(state.copyWith(userEntity: updatedUser));
    }
  }

  FutureOr<void> _updateProfileImage(
    UpdateProfileImageEvent event,
    emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _uploadFileUseCase(event.file);
    result.match(
      (failure) {
        emit(
          state.copyWith(apiErrorMessage: failure.message, isLoading: false),
        );
      },
      (files) {
        // emit(
        //   state.copyWith(
        //     isLoading: false,
        //   ),
        // );
        add(
          UpdateCurrentUserEvent(
            entity: UpdateProfileRequest(image: files.map((e) => e.url).first),
          ),
        );
      },
    );
  }

  FutureOr<void> _updateCurrentUser(UpdateCurrentUserEvent event, emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _profileUsecase(event.entity);
    await result.match(
      (failure) {
        emit(
          state.copyWith(isLoading: false, apiErrorMessage: failure.message),
        );
      },
      (user) async {
        final currentUser = user;
        await LocalStorageService().saveUser(UserModel.fromEntity(currentUser));
        emit(
          state.copyWith(
            isLoading: false,
            apiErrorMessage: '',
            userEntity: user,
          ),
        );
      },
    );
  }
}
