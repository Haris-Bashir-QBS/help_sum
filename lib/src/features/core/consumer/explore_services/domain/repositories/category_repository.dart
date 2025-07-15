import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/categories_response_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_services_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/merchant_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/request/Booking_request_model.dart';

abstract class CategoryRepository {
  Future<Either<Failure, CategoriesResponseEntity>> getCategories(
    GetCategoriesParams params,
  );
  Future<Either<Failure, ServicesResponseModel>> getServicesByCategory(
    GetServicesParams params,
  );
  Future<Either<Failure, MerchantResponseModel>> getNearbyMerchants(
    BookingRequestModel params,
  );
}
