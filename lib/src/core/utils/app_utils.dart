class AppUtils {
  static String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
  }
} 