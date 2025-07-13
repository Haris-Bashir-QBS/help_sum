import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/auth/data/models/request/resend_otp_request_model.dart';
import 'package:help_sum/src/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/use_cases/use_case.dart';

class ResendOtpUsecase extends UseCase<String, ResendOtpRequestModel> {
  final AuthRepository authRepository;
  ResendOtpUsecase(this.authRepository);
  @override
  Future<Either<Failure, String>> call(params) async {
    return await authRepository.resendOtp(params: params);
  }
}
