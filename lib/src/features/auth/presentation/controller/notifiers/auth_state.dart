import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

/// Login states
class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final UserEntity user;

  LoginSuccess(this.user);
}

class LoginError extends AuthState {
  final String message;
  LoginError(this.message);
}

/// Signup states
class SignupLoading extends AuthState {}

class SignupSuccess extends AuthState {
  final String userId;
  SignupSuccess(this.userId);
}

class SignupError extends AuthState {
  final String message;
  SignupError(this.message);
}

/// Signup states
class OtpLoading extends AuthState {}

class OtpSuccess extends AuthState {
  final UserEntity userEntity;
  OtpSuccess(this.userEntity);
}

class OtpError extends AuthState {
  final String message;
  OtpError(this.message);
}

class ResendOtpLoading extends AuthState {}

class ResendOtpSuccess extends AuthState {
  final String message;
  ResendOtpSuccess(this.message);
}

class ResendOtpError extends AuthState {
  final String message;
  ResendOtpError(this.message);
}

class UserState {
  final UserEntity? user;

  const UserState({this.user});

  UserState copyWith({UserEntity? user}) {
    return UserState(user: user ?? this.user);
  }
}
