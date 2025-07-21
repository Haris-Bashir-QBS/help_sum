import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/get_cards_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';

sealed class PaymentState {}

class PaymentInitial extends PaymentState {}

/// Add Card states
class AddCardLoading extends PaymentState {}

class AddCardSuccess extends PaymentState {
  final AddCardResponseModel response;
  AddCardSuccess(this.response);
}

class AddCardError extends PaymentState {
  final String message;
  AddCardError(this.message);
}

/// Get Cards states
class GetCardsLoading extends PaymentState {}

class GetCardsSuccess extends PaymentState {
  final GetCardsResponseModel response;
  GetCardsSuccess(this.response);
}

class GetCardsError extends PaymentState {
  final String message;
  GetCardsError(this.message);
}

/// Delete Card states
class DeleteCardLoading extends PaymentState {}

class DeleteCardSuccess extends PaymentState {
  final CardActionResponseModel response;
  DeleteCardSuccess(this.response);
}

class DeleteCardError extends PaymentState {
  final String message;
  DeleteCardError(this.message);
}

/// Set Default Card states
class SetDefaultCardLoading extends PaymentState {}

class SetDefaultCardSuccess extends PaymentState {
  final CardActionResponseModel response;
  SetDefaultCardSuccess(this.response);
}

class SetDefaultCardError extends PaymentState {
  final String message;
  SetDefaultCardError(this.message);
}

/// Pay For Job states
class PayForJobLoading extends PaymentState {}

class PayForJobSuccess extends PaymentState {
  final CardActionResponseModel response;
  PayForJobSuccess(this.response);
}

class PayForJobError extends PaymentState {
  final String message;
  PayForJobError(this.message);
}
