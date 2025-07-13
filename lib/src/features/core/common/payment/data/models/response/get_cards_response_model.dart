import 'add_card_response_model.dart';

class GetCardsResponseModel {
  final int status;
  final CardsList? cards;

  GetCardsResponseModel({required this.status, this.cards});

  factory GetCardsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCardsResponseModel(
      status: json['status'] ?? 0,
      cards: json['cards'] != null ? CardsList.fromJson(json['cards']) : null,
    );
  }
}

class CardsList {
  final String object;
  final List<CardData> data;
  final bool hasMore;
  final String url;

  CardsList({
    required this.object,
    required this.data,
    required this.hasMore,
    required this.url,
  });

  factory CardsList.fromJson(Map<String, dynamic> json) {
    return CardsList(
      object: json['object'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((card) => CardData.fromJson(card))
              .toList() ??
          [],
      hasMore: json['has_more'] ?? false,
      url: json['url'] ?? '',
    );
  }
}
