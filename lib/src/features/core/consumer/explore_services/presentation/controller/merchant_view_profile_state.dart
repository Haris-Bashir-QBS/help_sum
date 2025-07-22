import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';

class MerchantViewProfileState {
  const MerchantViewProfileState();
}

class MerchantViewProfileInitial extends MerchantViewProfileState {}

class MerchantViewProfileLoading extends MerchantViewProfileState {}

class MerchantViewProfileLoaded extends MerchantViewProfileState {
  final UserModel profile;
  MerchantViewProfileLoaded(this.profile);
}

class MerchantViewProfileError extends MerchantViewProfileState {
  final String message;
  MerchantViewProfileError({required this.message});
}
