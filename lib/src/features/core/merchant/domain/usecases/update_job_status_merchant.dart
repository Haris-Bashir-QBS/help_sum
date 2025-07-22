import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/merchant/domain/entities/merchant_job_request_resposne_entity.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/update_job_params.dart';
import 'package:help_sum/src/features/core/merchant/domain/repositories/merchant_jobs_repository.dart';

class UpdateJobStatusMerchantUseCase
    implements UseCase<JobData, UpdateJobParams> {
  final MerchantJobsRepository repository;

  UpdateJobStatusMerchantUseCase(this.repository);

  @override
  Future<Either<Failure, JobData>> call(UpdateJobParams params) async {
    return await repository.updateJob(params);
  }
}
