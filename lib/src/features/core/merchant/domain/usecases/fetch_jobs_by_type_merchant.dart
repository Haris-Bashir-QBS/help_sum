import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_params.dart';
import 'package:help_sum/src/features/core/merchant/domain/entities/merchant_job_request_resposne_entity.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';
import 'package:help_sum/src/features/core/merchant/domain/repositories/merchant_jobs_repository.dart';

class GetAllJobsByTypeUseCase
    implements UseCase<MerchantJobRequestsEntity, MerchantByTypeParam> {
  final MerchantJobsRepository repository;

  GetAllJobsByTypeUseCase(this.repository);

  @override
  Future<Either<Failure, MerchantJobRequestsEntity>> call(
    MerchantByTypeParam params,
  ) async {
    return await repository.getAllJobsByType(params);
  }
}
