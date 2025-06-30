import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/otp_use_case.dart';
import 'package:help_sum/src/features/auth/domain/usecases/signup_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_state.dart';
part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final LoginUseCase _loginUseCase = sl();
  late final SignupUseCase _signUpUseCase = sl();
  late final OtpUseCase _otpUseCase = sl();
  // late final LocalStorageService _localStorageService = sl();

  // User entity
  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  @override
  AuthState build() => AuthInitial();

  Future<void> login(LoginRequestModel params) async {
    state = LoginLoading();
    final result = await _loginUseCase(params);

    result.match((failure) => state = LoginError(failure.message), (
      user,
    ) async {
      _currentUser = user;
      await LocalStorageService().saveUser(
        UserModel.fromEntity(user),
      ); // ✅ Save to local storage
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

  Future<void> verifyOtp(OtpRequestModel params) async {
    state = OtpLoading();
    final result = await _otpUseCase(params);

    result.match((failure) => state = OtpError(failure.message), (user) async {
      _currentUser = user;
      await LocalStorageService().saveUser(
        UserModel.fromEntity(user),
      ); // ✅ Save to local storage
      state = OtpSuccess(user);
    });
  }

  Future<void> loadUserFromStorage() async {
    final savedUserModel = LocalStorageService().user;
    if (savedUserModel != null) {
      _currentUser = savedUserModel;
      state = LoginSuccess(_currentUser!);
    } else {
      state = AuthInitial();
    }
  }

  void reset() => state = AuthInitial();
}
