import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/resend_otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, (UserEntity, String)>> login({
    required LoginRequestModel params,
  });

  Future<Either<Failure, UserEntity>> verifyOtp({
    required OtpRequestModel params,
  });

  Future<Either<Failure, String>> resendOtp({
    required ResendOtpRequestModel params,
  });
  Future<Either<Failure, String>> signup({required SignUpRequestModel params});
}
