class AddCardResponseModel {
  final int status;
  final String message;
  final CardData? data;

  AddCardResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory AddCardResponseModel.fromJson(Map<String, dynamic> json) {
    return AddCardResponseModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? CardData.fromJson(json['data']) : null,
    );
  }
}

class CardData {
  final String id;
  final String object;
  final String? brand;
  final String? country;
  final int? expMonth;
  final int? expYear;
  final String? last4;

  CardData({
    required this.id,
    required this.object,
    this.brand,
    this.country,
    this.expMonth,
    this.expYear,
    this.last4,
  });

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['id'] ?? '',
      object: json['object'] ?? '',
      brand: json['brand'],
      country: json['country'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
      last4: json['last4']?.toString(),
    );
  }
}
