part of 'rating_bloc.dart';

sealed class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object> get props => [];
}

class UploadImage extends RatingEvent {}

class PostRating extends RatingEvent {
  final RateJobRequestModel rateJobRequestModel;

  const PostRating({required this.rateJobRequestModel});
}
