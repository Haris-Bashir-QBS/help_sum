part of 'verify_otp_bloc.dart';

class VerifyOtpState extends Equatable {
  const VerifyOtpState({
    this.isLoading = false,
    this.userEntity,
    this.apiErrorMessage = '',
    this.resendOtpMessage = '',
  });
  final bool isLoading;
  final String apiErrorMessage;
  final String resendOtpMessage;
  final UserEntity? userEntity;
  @override
  List<Object?> get props => [
    apiErrorMessage,
    userEntity,
    isLoading,
    resendOtpMessage,
  ];

  VerifyOtpState copyWith({
    bool? isLoading,
    String? apiErrorMessage,
    UserEntity? userEntity,
    String? resendOtpMessage,
  }) {
    return VerifyOtpState(
      isLoading: isLoading ?? this.isLoading,
      apiErrorMessage: apiErrorMessage ?? '',
      userEntity: userEntity,
      resendOtpMessage: resendOtpMessage ?? '',
    );
  }
}
