part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.isLoading = false,
    this.userEntity,
    this.apiErrorMessage = '',
    this.merchantSetupResposeEntitiy,
  });
  final bool isLoading;
  final String apiErrorMessage;
  final UserEntity? userEntity;
  final MerchantSetupResposeEntitiy? merchantSetupResposeEntitiy;
  @override
  List<Object?> get props => [
    apiErrorMessage,
    userEntity,
    isLoading,
    merchantSetupResposeEntitiy,
  ];

  LoginState copyWith({
    bool? isLoading,
    String? apiErrorMessage,
    UserEntity? userEntity,
    bool clearUser = false,
    MerchantSetupResposeEntitiy? merchantSetupResposeEntitiy,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      apiErrorMessage: apiErrorMessage ?? '',
      userEntity: clearUser ? null : userEntity ?? this.userEntity,
      merchantSetupResposeEntitiy: merchantSetupResposeEntitiy,
    );
  }
}
