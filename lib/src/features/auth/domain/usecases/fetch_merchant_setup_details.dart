import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/auth/domain/entities/merchant_setup_respose_entitiy.dart';
import 'package:help_sum/src/features/auth/domain/repositories/auth_repository.dart';

class FetchMerchantSetupDetails
    extends UseCase<MerchantSetupResponseEntitiy, NoParams> {
  final AuthRepository repository;

  FetchMerchantSetupDetails(this.repository);

  @override
  Future<Either<Failure, MerchantSetupResponseEntitiy>> call(
    NoParams params,
  ) async {
    return await repository.getMerchantSetupDetails();
  }
}
