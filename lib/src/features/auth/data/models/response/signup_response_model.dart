class SignupResponseModel {
  final bool? status;
  final int? code;
  final Data? data;
  final String? message;

  SignupResponseModel({this.status, this.code, this.data, this.message});

  SignupResponseModel.fromJson(Map<String, dynamic> json)
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
  final String? id;

  Data({this.id});

  Data.fromJson(Map<String, dynamic> json) : id = json['_id'] as String?;

  Map<String, dynamic> toJson() => {'_id': id};
}
