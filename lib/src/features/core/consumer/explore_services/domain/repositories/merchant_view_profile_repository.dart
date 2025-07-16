import '../entities/service_provider_model.dart';

abstract class MerchantViewProfileRepository {
  Future<ServiceProviderModel> fetchMerchantProfile(String merchantId);
}
