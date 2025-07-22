import 'package:fpdart/src/either.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/merchant/data/data_sources/remote/merchant_jobs_remote_source.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/update_job_params.dart';
import 'package:help_sum/src/features/core/merchant/domain/repositories/merchant_jobs_repository.dart';

class MerchantJobsRepositoryImpl implements MerchantJobsRepository {
  final MerchantJobsRemoteSource remoteDataSource;

  MerchantJobsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, JobResponseModel>> getAllJobsByType(
    MerchantByTypeParam params,
  ) async {
    try {
      final response = await remoteDataSource.getAllJobsByType(params);

      // final entity = CategoriesResponseEntity(
      //   status: response.status,
      //   code: response.code,
      //   message: response.message,
      //   data: CategoriesDataEntity(
      //     categories: response.data.categories,
      //     pagination: response.data.pagination,
      //   ),
      // );

      return right(response);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, JobData>> updateJob(UpdateJobParams params) async {
    try {
      final response = await remoteDataSource.updateJob(params);

      return right(response);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
