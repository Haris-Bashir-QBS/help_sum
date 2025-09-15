import 'dart:io';

class LoginRequestModel {
  final String phoneNumber;
  final String password;
  final String? fcmToken;

  LoginRequestModel({
    required this.phoneNumber,
    required this.password,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phoneNumber,
      'password': password,
      'userDeviceToken': fcmToken,
      'userDeviceType': Platform.operatingSystem,
    };
  }
}
