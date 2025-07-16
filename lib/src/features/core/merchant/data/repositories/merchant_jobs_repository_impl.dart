import 'package:fpdart/src/either.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_params.dart';
import 'package:help_sum/src/features/core/merchant/data/data_sources/remote/merchant_jobs_remote_source.dart';
import 'package:help_sum/src/features/core/merchant/domain/entities/merchant_job_request_resposne_entity.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';
import 'package:help_sum/src/features/core/merchant/domain/repositories/merchant_jobs_repository.dart';

class MerchantJobsRepositoryImpl implements MerchantJobsRepository {
  final MerchantJobsRemoteSource remoteDataSource;

  MerchantJobsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MerchantJobRequestsEntity>> getAllJobsByType(
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
}
