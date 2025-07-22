import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/update_job_params.dart';

abstract class MerchantJobsRemoteSource {
  Future<JobResponseModel> getAllJobsByType(MerchantByTypeParam params);
  Future<JobData> updateJob(UpdateJobParams params);
  Future<JobData> startJob(String jobId);
  Future<JobData> completeJob(String jobId);
}
