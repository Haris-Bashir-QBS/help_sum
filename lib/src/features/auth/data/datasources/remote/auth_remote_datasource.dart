import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/resend_otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';

import '../../models/response/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login({required LoginRequestModel params});
  Future<UserModel> verifyOtp({required OtpRequestModel params});
  Future<String> resendOtp({required ResendOtpRequestModel params});
  Future<String> signup({required SignUpRequestModel params});
}
