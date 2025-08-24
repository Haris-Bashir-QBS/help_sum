import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/resend_otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/merchant_setup_response_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/services_groupped_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/upload_file_response.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';

import '../../models/response/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<(UserModel, String)> login({required LoginRequestModel params});
  Future<(UserModel, String)> verifyOtp({required OtpRequestModel params});
  Future<String> resendOtp({required ResendOtpRequestModel params});
  Future<String> signup({required SignUpRequestModel params});
  Future<UserEntity> updateProfile({required UpdateProfileRequest params});
  Future<List<UploadedFileModel>> uploadFile({
    required UploadFileRequest params,
  });
  Future<List<GroupedCategoryModel>> getGroupedServices();
  Future<MerchantSetupResponseModel> getMerchantSetupDetails();
}
