class RateJobRequestModel {
  final String jobId;
  final int rating;
  final String review;

  RateJobRequestModel({
    required this.jobId,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'rating': rating,
      'review': review,
    };
  }
}