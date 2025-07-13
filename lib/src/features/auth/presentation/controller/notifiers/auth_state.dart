import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file.dart';
import 'package:help_sum/src/features/auth/domain/entities/services_gropped_entity.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/category_entity.dart';
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

class UpdateProfileLoading extends AuthState {}

class UpdateProfileSuccess extends AuthState {
  final UserEntity userEntity;
  UpdateProfileSuccess(this.userEntity);
}

class UpdateProfielError extends AuthState {
  final String message;
  UpdateProfielError(this.message);
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

class ServicesLoading extends AuthState {}

class ServicesSuccess extends AuthState {
  final bool isSearching;
  final bool savingSkills;
  final List<GroupedCategoryEntity> cats;
  final List<ServiceEntity> selectedServices;
  final List<GroupedCategoryEntity> filteredServices;

  ServicesSuccess(
    this.cats, {
    this.selectedServices = const [],
    this.filteredServices = const [],
    this.isSearching = false,
    this.savingSkills = false,
  });
}

class ServicesError extends AuthState {
  final String message;
  ServicesError(this.message);
}

class ScheduleLoading extends AuthState {}

class ScheduleSuccess extends AuthState {}

class ScheduleError extends AuthState {}

class RatesLoading extends AuthState {}

class RatesSuccess extends AuthState {}

class RatesError extends AuthState {}

class DescriptionLoading extends AuthState {}

class DescriptionSuccess extends AuthState {}

class DescriptionError extends AuthState {}

class UploadingFileLoading extends AuthState {}

class UploadingFileSuccess extends AuthState {
  final List<UploadedFileEntity> files;
  UploadingFileSuccess(this.files);
}

class UploadingFileError extends AuthState {
  final Failure failure;
  UploadingFileError(this.failure);
}

class SavePortfolioLoading extends AuthState {}

class SavePortfolioSuccess extends AuthState {}

class SavePortfolioError extends AuthState {
  final Failure failure;
  SavePortfolioError(this.failure);
}
