import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/merchant_setup_respose_entitiy.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/domain/usecases/fetch_merchant_setup_details.dart';
import 'package:help_sum/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final LoginUseCase _loginUseCase = sl();
  final LocalStorageService _localStorageService = LocalStorageService();
  late final FetchMerchantSetupDetails _fetchMerchantSetupDetails = sl();

  LoginBloc() : super(LoginState()) {
    on<LoginUser>((event, emit) async {
      emit(state.copyWith(isLoading: true, apiErrorMessage: ''));

      final result = await _loginUseCase(
        LoginRequestModel(
          phoneNumber: event.phoneNumber,
          password: event.password,
        ),
      );
      result.fold(
        (error) {
          emit(
            state.copyWith(isLoading: false, apiErrorMessage: error.message),
          );
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
    });
    on<UpdateUser>((event, emit) async {
      emit(state.copyWith(userEntity: event.userEntity));
      await _localStorageService.saveUser(
        UserModel.fromEntity(event.userEntity),
      );
    });

    on<CheckUserLoggedIn>((event, emit) async {
      final user = _localStorageService.user;
      if (user != null) {
        emit(state.copyWith(userEntity: user));
      } else {
        emit(state.copyWith(clearUser: true));
      }
    });
    on<LogoutUser>((event, emit) async {
      await _localStorageService.clearAll();
      emit(state.copyWith(userEntity: null, clearUser: true));
    });

    on<FetchMerchantAccount>((event, emit) async {
      AppUtils.showLoadingDialog(
        context: event.context,
        message: "Fetching Merchant Setup Details...",
      );
      final result = await _fetchMerchantSetupDetails(NoParams());
      AppUtils.closeLoadingDialog(event.context);
      result.match(
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
    });
  }
}
