class CardDetailParams {
  final double amount;
  final String cardNumber;
  final String cardHolderName;
  final String cvv;

  CardDetailParams({
    required this.amount,
    required this.cardNumber,
    required this.cardHolderName,
    required this.cvv,
  });
}
