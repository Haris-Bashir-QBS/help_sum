import 'package:help_sum/src/core/extensions/dio_extensions.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/network/client/dio_client.dart';
import 'package:help_sum/src/core/network/config/error_handler.dart';
import 'package:help_sum/src/features/core/common/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:help_sum/src/features/core/common/profile/data/models/response/rating_response_model.dart';
import 'package:help_sum/src/features/core/common/profile/domain/entities/rating_entity.dart';

class ProfileRemoteDataSourceImplementation implements ProfileRemoteDataSource {
  final DioClient _client;

  ProfileRemoteDataSourceImplementation({required DioClient client})
      : _client = client;

  @override
  Future<RatingResponseEntity> getMerchantRatings({
    required String merchantId,
  }) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.get(
        endpoint: '/rating/merchant/$merchantId',
      );

      if (response.isOk) {
        final ratingResponse = RatingResponseModel.fromJson(response.data);
        return ratingResponse.toEntity();
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'Failed to fetch ratings',
        );
      }
    });
  }
}
