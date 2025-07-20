import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import '../repositories/merchant_view_profile_repository.dart';
import '../entities/service_provider_model.dart';

class GetMerchantViewProfileParams {
  final String merchantId;
  GetMerchantViewProfileParams({required this.merchantId});
}

class GetMerchantViewProfileUseCase
    extends UseCase<ServiceProviderModel, GetMerchantViewProfileParams> {
  final MerchantViewProfileRepository repository;
  GetMerchantViewProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ServiceProviderModel>> call(
    GetMerchantViewProfileParams params,
  ) {
    return repository.fetchMerchantProfile(params.merchantId);
  }
}
