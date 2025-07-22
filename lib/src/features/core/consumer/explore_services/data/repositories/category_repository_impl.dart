import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/datasources/remote/category_remote_datasource.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/request/Booking_request_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/merchant_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/categories_response_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/repositories/category_repository.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_services_params.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CategoriesResponseEntity>> getCategories(
    GetCategoriesParams params,
  ) async {
    try {
      final response = await remoteDataSource.getCategories(params);

      final entity = CategoriesResponseEntity(
        status: response.status,
        code: response.code,
        message: response.message,
        data: CategoriesDataEntity(
          categories: response.data.categories,
          pagination: response.data.pagination,
        ),
      );

      return right(entity);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ServicesResponseModel>> getServicesByCategory(
    GetServicesParams params,
  ) async {
    try {
      final response = await remoteDataSource.getServicesByCategory(params);
      return right(response);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MerchantResponseModel>> getNearbyMerchants(
    BookingRequestModel params,
  ) async {
    try {
      final response = await remoteDataSource.getNearbyMerchants(params);
      return right(response);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
