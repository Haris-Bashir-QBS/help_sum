import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/merchant/domain/repositories/merchant_jobs_repository.dart';

class StartJobUseCase implements UseCase<JobData, String> {
  final MerchantJobsRepository repository;

  StartJobUseCase(this.repository);

  @override
  Future<Either<Failure, JobData>> call(String jobId) async {
    return await repository.startJob(jobId);
  }
}