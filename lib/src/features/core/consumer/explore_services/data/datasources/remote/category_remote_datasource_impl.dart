import 'package:flutter/material.dart';
import 'package:help_sum/src/core/constants/app_errors.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/extensions/dio_extensions.dart';
import 'package:help_sum/src/core/network/client/dio_client.dart';
import 'package:help_sum/src/core/network/config/api_endpoints.dart';
import 'package:help_sum/src/core/network/config/error_handler.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/datasources/remote/category_remote_datasource.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/request/Booking_request_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/get_categories_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/merchant_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_services_params.dart';

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

  @override
  Future<ServicesResponseModel> getServicesByCategory(
    GetServicesParams params,
  ) async {
    // return await ApiErrorHandler.executeGuarded(() async {
    final queryParams = <String, dynamic>{};
    if (params.page != null) queryParams['page'] = params.page;
    if (params.limit != null) queryParams['limit'] = params.limit;

    final response = await client.get(
      endpoint:
          "${ApiEndpoints.getServicesByCategory.value}/${params.categoryId}",
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.isOk) {
      ServicesResponseModel responseModel = ServicesResponseModel.fromJson(
        response.data,
      );
      return responseModel;
    } else {
      throw ServerException(
        statusCode: response.statusCode,
        message: response.data['message'] ?? AppErrors.somethingWentWrong,
      );
    }
    //  });
  }

  @override
  Future<MerchantResponseModel> getNearbyMerchants(
    BookingRequestModel params,
  ) async {
    //return await ApiErrorHandler.executeGuarded(() async {
    final response = await client.get(
      endpoint: ApiEndpoints.merchantsNearby.value,
      queryParams: {
        "latitude": params.lat,
        "longitude": params.long,
        //  "page": params.page,
        //  "limit": params.limit,
        "serviceIds": params.serviceId != null ? [params.serviceId] : [],
      },
    );
    if (response.isOk) {
      return MerchantResponseModel.fromJson(response.data);
    } else {
      throw ServerException(
        statusCode: response.statusCode,
        message: response.data['message'] ?? AppErrors.somethingWentWrong,
      );
    }
    //  });
  }
}
