part of 'signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({
    this.isLoading = false,
    this.userId = '',
    this.apiErrorMessage = '',
  });
  final bool isLoading;
  final String apiErrorMessage;
  final String userId;
  @override
  List<Object?> get props => [apiErrorMessage, userId, isLoading];

  SignupState copyWith({
    bool? isLoading,
    String? apiErrorMessage,
    String? userId,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      apiErrorMessage: apiErrorMessage ?? '',
      userId: userId ?? '',
    );
  }
}
