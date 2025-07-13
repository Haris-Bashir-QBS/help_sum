import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/add_card_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/domain/repositories/payment_repository.dart';

class AddCardUseCase
    extends UseCase<AddCardResponseModel, AddCardRequestModel> {
  final PaymentRepository _repository;

  AddCardUseCase(this._repository);

  @override
  Future<Either<Failure, AddCardResponseModel>> call(
    AddCardRequestModel params,
  ) async {
    return await _repository.addCard(params: params);
  }
}
