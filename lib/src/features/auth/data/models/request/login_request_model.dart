class LoginRequestModel {
  final String phoneNumber;
  final String password;

  LoginRequestModel({required this.phoneNumber, required this.password});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      phoneNumber: json['phone'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'phone': phoneNumber, 'password': password};
  }
}
