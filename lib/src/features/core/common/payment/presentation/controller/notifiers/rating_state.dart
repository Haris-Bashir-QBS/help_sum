import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';

sealed class RatingState {}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {
  final CardActionResponseModel response;
  RatingSuccess(this.response);
}

class RatingError extends RatingState {
  final String message;
  RatingError(this.message);
}