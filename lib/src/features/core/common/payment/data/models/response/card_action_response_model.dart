class CardActionResponseModel {
  final bool isSuccess;
  final String message;
  final Map<String, dynamic>? data;

  CardActionResponseModel({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  factory CardActionResponseModel.fromJson(Map<String, dynamic> json) {
    // Normalize status: can be int (1/0) or bool (true/false)
    bool success = false;
    final status = json['status'];
    if (status is int) {
      success = status == 1;
    } else if (status is bool) {
      success = status;
    } else if (status is String) {
      // optional: handle string "1"/"0"/"true"/"false"
      success = status == '1' || status.toLowerCase() == 'true';
    }

    return CardActionResponseModel(
      isSuccess: success,
      message: json['message'] ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
