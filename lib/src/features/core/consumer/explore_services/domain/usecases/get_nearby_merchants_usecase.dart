import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/request/Booking_request_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/merchant_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/repositories/category_repository.dart';

class GetNearbyMerchantsUseCase
    extends UseCase<MerchantResponseModel, BookingRequestModel> {
  final CategoryRepository repository;
  GetNearbyMerchantsUseCase(this.repository);

  @override
  Future<Either<Failure, MerchantResponseModel>> call(
    BookingRequestModel params,
  ) {
    return repository.getNearbyMerchants(params);
  }
}
