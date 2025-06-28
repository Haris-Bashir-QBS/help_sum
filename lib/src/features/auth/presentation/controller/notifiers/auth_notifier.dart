import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/signup_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_state.dart';
part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final LoginUseCase _loginUseCase = sl();
  late final SignupUseCase _signUpUseCase = sl();

  @override
  AuthState build() => AuthInitial();

  Future<void> login(LoginRequestModel params) async {
    state = LoginLoading();
    final result = await _loginUseCase(params);

    result.match(
      (failure) => state = LoginError(failure.message),
      (user) => state = LoginSuccess(user),
    );
  }

  Future<void> signup(SignUpRequestModel params) async {
    state = SignupLoading();
    final result = await _signUpUseCase(params);

    result.match(
      (failure) => state = SignupSuccess(failure.message),
      (user) => state = SignupError(user),
    );
  }

  void reset() => state = AuthInitial();
}
