import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/request/Booking_request_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/merchant_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/repositories/category_repository.dart';

class GetNearbyMerchantsUseCase {
  final CategoryRepository repository;
  GetNearbyMerchantsUseCase(this.repository);

  Future<Either<Failure, MerchantResponseModel>> call(
    BookingRequestModel params,
  ) {
    return repository.getNearbyMerchants(params);
  }
}
