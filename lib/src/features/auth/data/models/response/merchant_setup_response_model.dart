// {
//     "status": true,
//     "code": 200,
//     "data": "https://connect.stripe.com/setup/e/acct_1Rk7nX4gPXPTTo47/x1NymwwCMiNk",
//     "message": "Setup your merchant account"
// }

import 'package:help_sum/src/features/auth/domain/entities/merchant_setup_respose_entitiy.dart';

class MerchantSetupResponseModel extends MerchantSetupResposeEntitiy {
  final bool? status;
  final int? code;
  final String? data;
  final String? message;

  const MerchantSetupResponseModel({
    required this.status,
    required this.code,
    required this.data,
    required this.message,
  }) : super(url: data, message: message);

  factory MerchantSetupResponseModel.fromJson(Map<String, dynamic> json) {
    return MerchantSetupResponseModel(
      status: json['status'] as bool?,
      code: json['code'] as int?,
      data: json['data'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'code': code, 'data': data, 'message': message};
  }
}
