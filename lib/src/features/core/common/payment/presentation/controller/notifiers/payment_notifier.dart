import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/add_card_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/domain/usecases/add_card_usecase.dart';
import 'package:help_sum/src/features/core/common/payment/domain/usecases/get_cards_usecase.dart';
import 'package:help_sum/src/features/core/common/payment/domain/usecases/delete_card_usecase.dart';
import 'package:help_sum/src/features/core/common/payment/domain/usecases/set_default_card_usecase.dart';
import 'package:help_sum/src/features/core/common/payment/domain/usecases/pay_for_job_usecase.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'payment_state.dart';

class PaymentNotifier extends StateNotifier<PaymentState> {
  final AddCardUseCase _addCardUseCase;
  final GetCardsUseCase _getCardsUseCase;
  final DeleteCardUseCase _deleteCardUseCase;
  final SetDefaultCardUseCase _setDefaultCardUseCase;
  final PayForJobUseCase _payForJobUseCase;

  PaymentNotifier(
    this._addCardUseCase,
    this._getCardsUseCase,
    this._deleteCardUseCase,
    this._setDefaultCardUseCase,
    this._payForJobUseCase,
  ) : super(PaymentInitial());

  Future<void> addCard(AddCardRequestModel params) async {
    state = AddCardLoading();
    final result = await _addCardUseCase(params);

    result.match(
      (failure) => state = AddCardError(failure.message),
      (response) => state = AddCardSuccess(response),
    );
  }

  Future<void> getCards() async {
    state = GetCardsLoading();
    final result = await _getCardsUseCase(NoParams());

    result.match(
      (failure) => state = GetCardsError(failure.message),
      (response) => state = GetCardsSuccess(response),
    );
  }

  Future<void> deleteCard(String cardId) async {
    state = DeleteCardLoading();
    final result = await _deleteCardUseCase(DeleteCardParams(cardId: cardId));

    result.match(
      (failure) => state = DeleteCardError(failure.message),
      (response) => state = DeleteCardSuccess(response),
    );
  }

  Future<void> setDefaultCard(String cardId) async {
    state = SetDefaultCardLoading();
    final result = await _setDefaultCardUseCase(
      SetDefaultCardParams(cardId: cardId),
    );

    result.match(
      (failure) => state = SetDefaultCardError(failure.message),
      (response) => state = SetDefaultCardSuccess(response),
    );
  }

  Future<void> payForJob({
    required String jobId,
    required String paymentToken,
    required int amount,
  }) async {
    state = PayForJobLoading();
    final result = await _payForJobUseCase(
      PayForJobParams(jobId: jobId, paymentToken: paymentToken, amount: amount),
    );
    result.match(
      (failure) => state = PayForJobError(failure.message),
      (response) => state = PayForJobSuccess(response),
    );
  }
}

