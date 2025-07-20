import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/datasources/booking_remote_datasource.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_request_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, JobResponseModel>> createJob(
    JobRequestModel params,
  ) async {
    try {
      final response = await remoteDataSource.createJob(params);
      return right(response);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, JobResponseModel>> fetchJobsByType(
    String type, {
    int? page,
    int? limit,
  }) async {
    try {
      final response = await remoteDataSource.fetchJobsByType(
        type,
        page: page,
        limit: limit,
      );
      return right(response);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
