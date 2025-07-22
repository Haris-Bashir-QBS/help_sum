import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/app_secrets.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/services/stripe_service.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/add_card_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/notifiers/payment_state.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/providers/payment_provider.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/models/card_detail_params.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/widgets/card_details_form.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';

class CardDetailsScreen extends ConsumerStatefulWidget {
  const CardDetailsScreen({super.key});

  @override
  ConsumerState<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends ConsumerState<CardDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _tipController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.cardDetails, centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Expanded(
                child: CardDetailsForm(
                  formKey: _formKey,
                  cardNumberController: _cardNumberController,
                  expiryDateController: _expiryDateController,
                  cvvController: _cvvController,
                  tipController: _tipController,
                  emailController: _emailController,
                  showTipAndEmail: true,
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final paymentState = ref.watch(paymentNotifierProvider);

                  return CustomButton(
                    text:
                        paymentState is AddCardLoading
                            ? AppTexts.processingPayment
                            : AppTexts.done,
                    color: AppPalette.primaryColor,
                    isLoading: paymentState is AddCardLoading,
                    textColor: Colors.white,
                    onPressed:
                        paymentState is AddCardLoading
                            ? () {}
                            : () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
                                _handleCardDetailsSubmitted();
                              }
                            },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================== Card Details ===========================
  Future<void> _handleCardDetailsSubmitted() async {
    try {
      // Extract card details
      final cardNumber = _cardNumberController.text.replaceAll(' ', '');
      final expiryDate = _expiryDateController.text;
      final cvv = _cvvController.text;

      // Parse expiry date
      final parts = expiryDate.split('/');
      if (parts.length != 2) {
        AppUtils.showSnackBar(context, 'Invalid expiry date format');
        return;
      }

      final month = int.parse(parts[0]);
      final year = 2000 + int.parse(parts[1]); // Convert YY to YYYY

      // Get card token from Stripe
      final cardToken = await StripeService.instance.getCardToken(
        cardNumber: cardNumber,
        expMonth: month,
        expYear: year,
        cvc: cvv,
        publicKey: AppSecrets.stripePublicKey,
        name: _emailController.text.isNotEmpty ? _emailController.text : null,
      );

      if (cardToken == null) {
        if(!mounted)return;
        AppUtils.showSnackBar(context, 'Failed to create card token');
        return;
      }

      // Create request model
      final requestModel = AddCardRequestModel(cardTokenId: cardToken);

      // Call payment notifier
      await ref.read(paymentNotifierProvider.notifier).addCard(requestModel);

      // Listen to state changes
      ref.listen(paymentNotifierProvider, (previous, next) {
        if (next is AddCardSuccess) {
          AppUtils.showSnackBar(context, 'Card added successfully!');
          context.pushNamed(
            AppRoutes.paymentConfirmation,
            extra: CardDetailParams(
              amount: 100.0,
              cardNumber: AppUtils.maskCardNumber(cardNumber),
              cardHolderName: _emailController.text,
              cvv: cvv,
            ),
          );
        } else if (next is AddCardError) {
          AppUtils.showSnackBar(context, next.message);
        }
      });
    } catch (e) {
      AppUtils.showSnackBar(context, 'Error processing card: $e');
    }
  }
}
