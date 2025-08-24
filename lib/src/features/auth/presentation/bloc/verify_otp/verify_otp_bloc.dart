import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/resend_otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/domain/usecases/otp_use_case.dart';
import 'package:help_sum/src/features/auth/domain/usecases/resend_otp_usecase.dart';
part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  late final OtpUseCase _otpUseCase = sl();
  late final ResendOtpUsecase _resendOtpUsecase = sl();
  final LocalStorageService _localStorageService = LocalStorageService();

  VerifyOtpBloc() : super(VerifyOtpState()) {
    on<VerifyOtpSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final result = await _otpUseCase(event.params);

      await result.fold(
        (error) {
          emit(
            state.copyWith(isLoading: false, apiErrorMessage: error.message),
          );
        },

        (user) async {
          final (userInfo, token) = user;
          await _localStorageService.saveUser(UserModel.fromEntity(userInfo));
          await _localStorageService.saveAccessToken(token);
          emit(
            state.copyWith(
              isLoading: false,
              apiErrorMessage: '',
              userEntity: userInfo,
            ),
          );
        },
      );
    });

    on<ResendOtpRequested>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await _resendOtpUsecase(event.params);

      result.match(
        (failure) {
          emit(
            state.copyWith(isLoading: false, apiErrorMessage: failure.message),
          );
        },
        (message) async {
          emit(state.copyWith(resendOtpMessage: message, isLoading: false));
        },
      );
    });
  }
}
