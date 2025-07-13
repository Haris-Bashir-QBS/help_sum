class AddCardRequestModel {
  final String cardTokenId;

  AddCardRequestModel({required this.cardTokenId});

  Map<String, dynamic> toJson() {
    return {'cardTokenId': cardTokenId};
  }
}
