import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/domain/repositories/payment_repository.dart';

class DeleteCardParams {
  final String cardId;
  DeleteCardParams({required this.cardId});
}

class DeleteCardUseCase
    extends UseCase<CardActionResponseModel, DeleteCardParams> {
  final PaymentRepository _repository;

  DeleteCardUseCase(this._repository);

  @override
  Future<Either<Failure, CardActionResponseModel>> call(
    DeleteCardParams params,
  ) async {
    return await _repository.deleteCard(cardId: params.cardId);
  }
}
