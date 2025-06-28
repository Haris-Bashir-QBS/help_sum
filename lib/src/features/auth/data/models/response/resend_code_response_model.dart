class ResendCodeResponseModel {
  final bool? status;
  final int? code;
  final String? message;

  ResendCodeResponseModel({this.status, this.code, this.message});

  ResendCodeResponseModel.fromJson(Map<String, dynamic> json)
    : status = json['status'] as bool?,
      code = json['code'] as int?,
      message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
  };
}
