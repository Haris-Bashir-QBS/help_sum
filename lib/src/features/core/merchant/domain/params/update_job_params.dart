class UpdateJobParams {
  final String? jobId;
  final String? action;
  final double? newHours;
  final double? newOffer;

  UpdateJobParams({this.jobId, this.action, this.newHours, this.newOffer});

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'action': action,
      'newHours': newHours,
      'newOffer': newOffer,
    };
  }
}
