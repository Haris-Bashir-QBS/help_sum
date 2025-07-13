import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/resend_otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request.dart';
import 'package:help_sum/src/features/auth/domain/entities/services_gropped_entity.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/category_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/category_entity.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, (UserEntity, String)>> login({
    required LoginRequestModel params,
  });

  Future<Either<Failure, UserEntity>> verifyOtp({
    required OtpRequestModel params,
  });
  Future<Either<Failure, List<UploadedFileEntity>>> uploadFile({
    required UploadFileRequest params,
  });

  Future<Either<Failure, String>> resendOtp({
    required ResendOtpRequestModel params,
  });
  Future<Either<Failure, String>> signup({required SignUpRequestModel params});

  Future<Either<Failure, UserEntity>> updateProfile({
    required UpdateProfileRequest params,
  });

  Future<Either<Failure, List<GroupedCategoryEntity>>> getServices();
}
