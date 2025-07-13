import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/use_cases/use_case.dart';

class SignupUseCase extends UseCase<String, SignUpRequestModel> {
  final AuthRepository authRepository;

  SignupUseCase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(params) async {
    return await authRepository.signup(params: params);
  }
}
