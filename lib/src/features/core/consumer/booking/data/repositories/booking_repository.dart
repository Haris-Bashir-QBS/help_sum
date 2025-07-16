import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_request_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';

abstract class BookingRepository {
  Future<Either<Failure, JobResponseModel>> createJob(JobRequestModel params);
  Future<Either<Failure, JobResponseModel>> fetchJobsByType(String type);
}
