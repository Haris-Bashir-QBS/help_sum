class ResendOtpRequestModel {
  final String userId;
  ResendOtpRequestModel({required this.userId});

  Map<String, dynamic> toJson() {
    return {'userId': userId};
  }
}
