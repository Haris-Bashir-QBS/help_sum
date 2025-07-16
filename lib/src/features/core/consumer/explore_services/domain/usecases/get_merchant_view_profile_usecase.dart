import '../repositories/merchant_view_profile_repository.dart';
import '../entities/service_provider_model.dart';

class GetMerchantViewProfileUseCase {
  final MerchantViewProfileRepository repository;
  GetMerchantViewProfileUseCase(this.repository);

  Future<ServiceProviderModel> call(String merchantId) {
    return repository.fetchMerchantProfile(merchantId);
  }
}
