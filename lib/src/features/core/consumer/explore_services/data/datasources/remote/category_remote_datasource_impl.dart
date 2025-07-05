import 'package:help_sum/src/core/constants/app_errors.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/extensions/dio_extensions.dart';
import 'package:help_sum/src/core/network/client/dio_client.dart';
import 'package:help_sum/src/core/network/config/api_endpoints.dart';
import 'package:help_sum/src/core/network/config/error_handler.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/datasources/remote/category_remote_datasource.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/get_categories_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_usecase.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final DioClient client;

  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<GetCategoriesResponseModel> getCategories(
    GetCategoriesParams params,
  ) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await client.get(
        endpoint: ApiEndpoints.categories.value,
        queryParams: {'page': params.page, 'limit': params.limit},
      );

      if (response.isOk) {
        return GetCategoriesResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }
}
