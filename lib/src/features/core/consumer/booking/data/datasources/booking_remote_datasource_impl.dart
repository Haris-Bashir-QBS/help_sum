import 'package:help_sum/src/core/network/client/dio_client.dart';
import 'package:help_sum/src/core/network/config/api_endpoints.dart';
import 'package:help_sum/src/core/network/config/error_handler.dart';
import 'package:help_sum/src/core/constants/app_errors.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/datasources/booking_remote_datasource.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_request_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/core/extensions/dio_extensions.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final DioClient client;
  BookingRemoteDataSourceImpl({required this.client});

  @override
  Future<JobResponseModel> createJob(JobRequestModel params) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await client.post(
        endpoint: ApiEndpoints.createJob.value,
        data: params.toJson(),
      );
      if (response.isCreated) {
        return JobResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<JobResponseModel> fetchJobsByType(String type) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await client.get(
        endpoint: "${ApiEndpoints.fetchJobs.value}/$type",
        // queryParams: {'type': type},
      );
      if (response.isOk) {
        return JobResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }
}
