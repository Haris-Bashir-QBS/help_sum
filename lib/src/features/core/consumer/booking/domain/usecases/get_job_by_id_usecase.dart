import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/domain/repositories/booking_repository.dart';

import '../../../../../../core/errors/api_exceptions.dart';
import '../../../../../../core/use_cases/use_case.dart';

class GetJobByIdUseCase extends UseCase<JobData, String> {
  final BookingRepository repository;
  GetJobByIdUseCase(this.repository);

  @override
  Future<Either<Failure, JobData>> call(String id) async {
    return await repository.getJobById(id);
  }
}
