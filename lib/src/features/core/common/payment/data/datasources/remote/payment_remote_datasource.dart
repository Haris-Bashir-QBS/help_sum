import 'package:help_sum/src/features/core/common/payment/data/models/request/add_card_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/get_cards_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';

abstract interface class PaymentRemoteDataSource {
  Future<AddCardResponseModel> addCard({required AddCardRequestModel params});
  Future<GetCardsResponseModel> getCards();
  Future<CardActionResponseModel> deleteCard({required String cardId});
  Future<CardActionResponseModel> setDefaultCard({required String cardId});
  Future<CardActionResponseModel> payForJob({
    required String jobId,
    required String paymentToken,
    required int amount,
  });
}
