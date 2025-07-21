import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/add_card_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/get_cards_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';

abstract interface class PaymentRepository {
  Future<Either<Failure, AddCardResponseModel>> addCard({
    required AddCardRequestModel params,
  });
  Future<Either<Failure, GetCardsResponseModel>> getCards();
  Future<Either<Failure, CardActionResponseModel>> deleteCard({
    required String cardId,
  });
  Future<Either<Failure, CardActionResponseModel>> setDefaultCard({
    required String cardId,
  });
  Future<Either<Failure, CardActionResponseModel>> payForJob({
    required String jobId,
    required String paymentToken,
    required int amount,
  });
}
