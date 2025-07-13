// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._internal();
  static final StripeService _instance = StripeService._internal();
  factory StripeService() => _instance;

  /// Returns the singleton instance
  static StripeService get instance => _instance;
  Future<String?> getCardToken({
    required String cardNumber,
    required int expMonth,
    required int expYear,
    required String cvc,
    required String publicKey,
    String? name,
  }) async {
    String? cardToken;
    try {
      // Set the publishable key
      Stripe.publishableKey = publicKey;

      final cardDetails = CardDetails(
        number: cardNumber,
        expirationMonth: expMonth,
        expirationYear: expYear,
        cvc: cvc,
      );
      Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);
      final tokenData = await Stripe.instance.createToken(
        CreateTokenParams.card(params: CardTokenParams(name: name)),
      );
      debugPrint('Token Data: \\${tokenData}');
      cardToken = tokenData.id;
    } on StripeException catch (ex) {
      log('StripeException: ${ex.error.message ?? ''}');
    } catch (ex) {
      log('Error: $ex');
    }
    return cardToken;
  }
}
