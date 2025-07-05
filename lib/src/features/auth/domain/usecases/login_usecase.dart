import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase extends UseCase<(UserEntity, String), LoginRequestModel> {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  @override
  Future<Either<Failure, (UserEntity, String)>> call(params) async {
    return await authRepository.login(params: params);
  }
}
