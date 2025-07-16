import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_params.dart';
import 'package:help_sum/src/features/core/merchant/data/models/response/merchant_job_requests_response_model.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';

abstract class MerchantJobsRemoteSource {
  Future<MerchantJobRequestsModel> getAllJobsByType(MerchantByTypeParam params);
}
