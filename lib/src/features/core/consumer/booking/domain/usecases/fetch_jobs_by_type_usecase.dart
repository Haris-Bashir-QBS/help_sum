import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/repositories/booking_repository.dart';

class FetchJobsByTypeUseCase {
  final BookingRepository repository;
  FetchJobsByTypeUseCase(this.repository);

  Future<Either<Failure, JobResponseModel>> call(String type) {
    return repository.fetchJobsByType(type);
  }
} 