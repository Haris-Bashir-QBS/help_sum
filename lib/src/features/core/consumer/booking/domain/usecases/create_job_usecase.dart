import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_request_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/domain/repositories/booking_repository.dart';

class CreateJobUseCase extends UseCase<JobResponseModel, JobRequestModel> {
  final BookingRepository repository;
  CreateJobUseCase(this.repository);

  @override
  Future<Either<Failure, JobResponseModel>> call(JobRequestModel params) {
    return repository.createJob(params);
  }
}
