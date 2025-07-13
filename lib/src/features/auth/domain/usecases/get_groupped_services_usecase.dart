import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/auth/domain/entities/services_gropped_entity.dart';
import 'package:help_sum/src/features/auth/domain/repositories/auth_repository.dart';

class GetGroupedServicesUseCase
    extends UseCase<List<GroupedCategoryEntity>, NoParams> {
  final AuthRepository repository;

  GetGroupedServicesUseCase(this.repository);

  @override
  Future<Either<Failure, List<GroupedCategoryEntity>>> call(
    NoParams params,
  ) async {
    return await repository.getServices();
  }
}
