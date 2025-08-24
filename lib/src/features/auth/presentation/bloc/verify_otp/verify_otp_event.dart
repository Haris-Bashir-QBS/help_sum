part of 'verify_otp_bloc.dart';

class VerifyOtpEvent {}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  final OtpRequestModel params;

  VerifyOtpSubmitted({required this.params});
}

class ResendOtpRequested extends VerifyOtpEvent {
  final ResendOtpRequestModel params;

  ResendOtpRequested({required this.params});
}
