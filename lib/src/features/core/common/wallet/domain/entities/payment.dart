class UserSummary {
  final String id;
  final String? image;
  final String? firstName;
  final String? lastName;

  UserSummary({required this.id, this.image, this.firstName, this.lastName});

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      id: json['_id'] as String,
      image: json['image'] ?? "",
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'image': image,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

class Payment {
  final String jobId;
  final String title;
  final double amount;
  final String status;
  final DateTime at;
  final UserSummary withUser;

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
      withUser: UserSummary.fromJson(json['withUser'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'title': title,
      'amount': amount,
      'status': status,
      'at': at.toIso8601String(),
      'withUser': withUser.toJson(),
    };
  }
}
