import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/update_job_params.dart';

abstract class MerchantJobsRepository {
  Future<Either<Failure, JobResponseModel>> getAllJobsByType(
    MerchantByTypeParam params,
  );

  Future<Either<Failure, JobData>> updateJob(UpdateJobParams params);

  ///Change Job Status
}
