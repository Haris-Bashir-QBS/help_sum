import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/repositories/booking_repository.dart';

class FetchJobsByTypeParams {
  final String type;
  final int? page;
  final int? limit;

  FetchJobsByTypeParams({required this.type, this.page, this.limit});
}

class FetchJobsByTypeUseCase
    extends UseCase<JobResponseModel, FetchJobsByTypeParams> {
  final BookingRepository repository;
  FetchJobsByTypeUseCase(this.repository);

  @override
  Future<Either<Failure, JobResponseModel>> call(FetchJobsByTypeParams params) {
    return repository.fetchJobsByType(
      params.type,
      page: params.page,
      limit: params.limit,
    );
  }
}
