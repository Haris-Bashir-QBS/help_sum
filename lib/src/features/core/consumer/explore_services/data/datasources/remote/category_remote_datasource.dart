import 'package:help_sum/src/features/core/consumer/explore_services/data/models/request/Booking_request_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/get_categories_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/merchant_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_services_params.dart';

abstract class CategoryRemoteDataSource {
  Future<GetCategoriesResponseModel> getCategories(GetCategoriesParams params);
  Future<ServicesResponseModel> getServicesByCategory(GetServicesParams params);
  Future<MerchantResponseModel> getNearbyMerchants(BookingRequestModel params);
}
