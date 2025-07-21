import 'package:help_sum/src/core/constants/app_errors.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/extensions/dio_extensions.dart';
import 'package:help_sum/src/core/network/client/dio_client.dart';
import 'package:help_sum/src/core/network/config/api_endpoints.dart';
import 'package:help_sum/src/core/network/config/error_handler.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_params.dart';
import 'package:help_sum/src/features/core/merchant/data/data_sources/remote/merchant_jobs_remote_source.dart';
import 'package:help_sum/src/features/core/merchant/data/models/response/merchant_job_requests_response_model.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/update_job_params.dart';

class MerchantJobsRemoteSourceImpl implements MerchantJobsRemoteSource {
  final DioClient client;

  MerchantJobsRemoteSourceImpl({required this.client});

  @override
  Future<MerchantJobRequestsModel> getAllJobsByType(
    MerchantByTypeParam params,
  ) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await client.get(
        endpoint: "${ApiEndpoints.jobMerchantByType.value}/${params.jobType}",
        // queryParams: {'page': params.page, 'limit': params.limit},
      );

      if (response.isOk) {
        return MerchantJobRequestsModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<JobRequestModel> updateJob(UpdateJobParams params) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await client.put(
        endpoint:
            "${ApiEndpoints.createJob.value}/${params.jobId}/merchant/respond",
        // queryParams: {'page': params.page, 'limit': params.limit},
        data: params.toJson(),
      );

      if (response.isOk) {
        return JobRequestModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }
}
