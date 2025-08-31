part of 'login_bloc.dart';

sealed class LoginEvent {
  const LoginEvent();
}

class LoginUser extends LoginEvent {
  final String phoneNumber;
  final String password;
  const LoginUser({required this.phoneNumber, required this.password});
}

class UpdateUser extends LoginEvent {
  final UserEntity userEntity;
  const UpdateUser({required this.userEntity});
}

class CheckUserLoggedIn extends LoginEvent {
  const CheckUserLoggedIn();
}

class LogoutUser extends LoginEvent {
  const LogoutUser();
}

class FetchMerchantAccount extends LoginEvent {
  final BuildContext context;
  const FetchMerchantAccount({required this.context});
}

class UpdateHourlyRateEvent extends LoginEvent {
  final String newRate;
  const UpdateHourlyRateEvent(this.newRate);
}

class UpdateDescriptionEvent extends LoginEvent {
  final String newDescription;
  const UpdateDescriptionEvent(this.newDescription);
}
