class OtpRequestModel {
  final String userId;
  final dynamic otp;
  OtpRequestModel({required this.userId, required this.otp});

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'otp': otp};
  }
}
