import 'package:help_sum/src/features/core/common/main_navigation/domain/model/job_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_request_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';

abstract class BookingRemoteDataSource {
  Future<JobResponseModel> createJob(JobRequestModel params);
  Future<JobResponseModel> fetchJobsByType(
    String type, {
    int? page,
    int? limit,
  });
  Future<JobData> getJobById(String id);
}
