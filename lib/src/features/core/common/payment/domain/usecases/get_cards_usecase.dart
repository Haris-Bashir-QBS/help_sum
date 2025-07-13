import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/get_cards_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/domain/repositories/payment_repository.dart';

class GetCardsUseCase extends UseCase<GetCardsResponseModel, NoParams> {
  final PaymentRepository _repository;

  GetCardsUseCase(this._repository);

  @override
  Future<Either<Failure, GetCardsResponseModel>> call(NoParams params) async {
    return await _repository.getCards();
  }
}
