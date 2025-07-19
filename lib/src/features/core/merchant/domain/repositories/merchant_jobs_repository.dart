import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_params.dart';
import 'package:help_sum/src/features/core/merchant/domain/entities/merchant_job_request_resposne_entity.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';

abstract class MerchantJobsRepository {
  Future<Either<Failure, MerchantJobRequestsEntity>> getAllJobsByType(
    MerchantByTypeParam params,
  );

  ///Change Job Status 
}
