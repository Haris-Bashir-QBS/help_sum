import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';

class LoginResponseModel {
  final bool? status;
  final int? code;
  final Data? data;
  final String? message;

  LoginResponseModel({this.status, this.code, this.data, this.message});

  LoginResponseModel.fromJson(Map<String, dynamic> json)
    : status = json['status'] as bool?,
      code = json['code'] as int?,
      data =
          (json['data'] as Map<String, dynamic>?) != null
              ? Data.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'data': data?.toJson(),
    'message': message,
  };
}

class Data {
  final String? token;
  final UserModel? userDetail;

  Data({this.token, this.userDetail});

  Data.fromJson(Map<String, dynamic> json)
    : token = json['token'] as String?,
      userDetail =
          (json['userDetail'] as Map<String, dynamic>?) != null
              ? UserModel.fromJson(json['userDetail'] as Map<String, dynamic>)
              : null;

  Map<String, dynamic> toJson() => {
    'token': token,
    'userDetail': userDetail?.toJson(),
  };
}
