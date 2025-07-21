import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/domain/repositories/payment_repository.dart';

class PayForJobParams {
  final String jobId;
  final String paymentToken;
  final int amount;
  PayForJobParams({
    required this.jobId,
    required this.paymentToken,
    required this.amount,
  });
}

class PayForJobUseCase
    extends UseCase<CardActionResponseModel, PayForJobParams> {
  final PaymentRepository _repository;
  PayForJobUseCase(this._repository);

  @override
  Future<Either<Failure, CardActionResponseModel>> call(
    PayForJobParams params,
  ) async {
    return await _repository.payForJob(
      jobId: params.jobId,
      paymentToken: params.paymentToken,
      amount: params.amount,
    );
  }
}
