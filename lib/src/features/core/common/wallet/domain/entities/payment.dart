class Payment {
  final String jobId;
  final String title;
  final double amount;
  final String status;
  final DateTime at;
  final String withUser;

  Payment({
    required this.jobId,
    required this.title,
    required this.amount,
    required this.status,
    required this.at,
    required this.withUser,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      jobId: json['jobId'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      at: DateTime.parse(json['at']),
      withUser: json['withUser'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'title': title,
      'amount': amount,
      'status': status,
      'at': at.toIso8601String(),
      'withUser': withUser,
    };
  }
}
