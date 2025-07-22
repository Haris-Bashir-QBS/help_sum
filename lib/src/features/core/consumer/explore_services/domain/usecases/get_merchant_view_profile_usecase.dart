import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';

import '../repositories/merchant_view_profile_repository.dart';

class GetMerchantViewProfileParams {
  final String merchantId;
  GetMerchantViewProfileParams({required this.merchantId});
}

class GetMerchantViewProfileUseCase
    extends UseCase<UserModel, GetMerchantViewProfileParams> {
  final MerchantViewProfileRepository repository;
  GetMerchantViewProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(GetMerchantViewProfileParams params) {
    return repository.fetchMerchantProfile(params.merchantId);
  }
}
