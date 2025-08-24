part of 'signup_bloc.dart';

abstract class SignupEvent {}

class SignupButtonPressed extends SignupEvent {
  final SignUpRequestModel signUpRequestModel;
  SignupButtonPressed({required this.signUpRequestModel});
}
