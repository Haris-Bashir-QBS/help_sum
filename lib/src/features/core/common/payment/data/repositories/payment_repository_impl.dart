import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/common/payment/data/datasources/remote/payment_remote_datasource.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/add_card_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/get_cards_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImplementation implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImplementation({
    required PaymentRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, AddCardResponseModel>> addCard({
    required AddCardRequestModel params,
  }) async {
    try {
      final response = await _remoteDataSource.addCard(params: params);
      return right(response);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, GetCardsResponseModel>> getCards() async {
    try {
      final response = await _remoteDataSource.getCards();
      return right(response);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, CardActionResponseModel>> deleteCard({
    required String cardId,
  }) async {
    try {
      final response = await _remoteDataSource.deleteCard(cardId: cardId);
      return right(response);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, CardActionResponseModel>> setDefaultCard({
    required String cardId,
  }) async {
    try {
      final response = await _remoteDataSource.setDefaultCard(cardId: cardId);
      return right(response);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
