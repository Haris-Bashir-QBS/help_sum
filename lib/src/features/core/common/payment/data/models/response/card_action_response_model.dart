class CardActionResponseModel {
  final int status;
  final String message;
  final Map<String, dynamic>? data;

  CardActionResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory CardActionResponseModel.fromJson(Map<String, dynamic> json) {
    return CardActionResponseModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
