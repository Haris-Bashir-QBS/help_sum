import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/domain/repositories/payment_repository.dart';

class SetDefaultCardParams {
  final String cardId;
  SetDefaultCardParams({required this.cardId});
}

class SetDefaultCardUseCase
    extends UseCase<CardActionResponseModel, SetDefaultCardParams> {
  final PaymentRepository _repository;

  SetDefaultCardUseCase(this._repository);

  @override
  Future<Either<Failure, CardActionResponseModel>> call(
    SetDefaultCardParams params,
  ) async {
    return await _repository.setDefaultCard(cardId: params.cardId);
  }
}
