import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/rate_job_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/domain/repositories/payment_repository.dart';

class RateJobUseCase
    implements UseCase<CardActionResponseModel, RateJobRequestModel> {
  final PaymentRepository _repository;

  RateJobUseCase({required PaymentRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CardActionResponseModel>> call(
    RateJobRequestModel params,
  ) {
    return _repository.rateJob(params: params);
  }
}
