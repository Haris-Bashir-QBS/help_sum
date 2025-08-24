import 'package:bloc/bloc.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/auth/domain/usecases/signup_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
part 'signup_state.dart';
part 'signup_event.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  late final SignupUseCase _signupUseCase = sl();

  SignupBloc() : super(SignupState()) {
    on<SignupButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final result = await _signupUseCase(event.signUpRequestModel);
      result.fold(
        (error) {
          emit(
            state.copyWith(isLoading: false, apiErrorMessage: error.message),
          );
        },
        (success) async {
          emit(
            state.copyWith(
              isLoading: false,
              userId: success,
              apiErrorMessage: '',
            ),
          );
        },
      );
    });
  }
}
