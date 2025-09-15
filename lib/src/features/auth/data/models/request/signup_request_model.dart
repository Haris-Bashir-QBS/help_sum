import 'dart:io';

class SignUpRequestModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String password;
  final bool isConsumer;
  final bool isMerchant;
  final String? fcmToken;

  SignUpRequestModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.password,
    required this.isConsumer,
    required this.isMerchant,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'password': password,
      'isConsumer': isConsumer,
      'isMerchant': isMerchant,
      'userDeviceToken': fcmToken,
      'userDeviceType': Platform.operatingSystem,
    };
  }
}
