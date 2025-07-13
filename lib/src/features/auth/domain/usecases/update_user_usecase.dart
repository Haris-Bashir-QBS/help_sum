import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/use_cases/use_case.dart';

class UpdateUserProfileUsecase
    extends UseCase<UserEntity, UpdateProfileRequest> {
  final AuthRepository authRepository;
  UpdateUserProfileUsecase(this.authRepository);
  @override
  Future<Either<Failure, UserEntity>> call(params) async {
    return await authRepository.updateProfile(params: params);
  }
}
