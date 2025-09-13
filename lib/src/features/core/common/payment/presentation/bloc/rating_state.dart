import 'package:equatable/equatable.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';

sealed class RatingState extends Equatable {}

class RatingInitial extends RatingState {
  @override
  List<Object?> get props => [];
}

class RatingLoading extends RatingState {
  @override
  List<Object?> get props => [];
}

class RatingSuccess extends RatingState {
  final CardActionResponseModel response;
  RatingSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class RatingError extends RatingState {
  final String message;
  RatingError(this.message);

  @override
  List<Object?> get props => [];
}
