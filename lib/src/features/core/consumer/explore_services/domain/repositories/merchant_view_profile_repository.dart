import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import '../entities/service_provider_model.dart';

abstract class MerchantViewProfileRepository {
  Future<Either<Failure, ServiceProviderModel>> fetchMerchantProfile(
    String merchantId,
  );
}
