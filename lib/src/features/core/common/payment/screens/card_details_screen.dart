import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/common/payment/models/card_detail_params.dart';
import 'package:help_sum/src/features/core/common/payment/widgets/card_details_form.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppTexts.cardDetails,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardDetailsForm(
              onSubmit: _handleCardDetailsSubmitted,
            ),
            const Spacer(),
            CustomButton(
              text: AppTexts.payNow,
              onPressed: () {
                // Handle payment
              },
            ),
          ],
        ),
      ),
    );
  }


/// ================== Card Details ===========================
   void _handleCardDetailsSubmitted(
    String cardNumber,
    String cardHolder,
    String expiryDate,
    String cvv,
  ) {
  
    context.pushNamed(
      AppRoutes.paymentConfirmation,
      extra: CardDetailParams(
        amount: 100.0,
        cardNumber: cardNumber,
        cardHolderName: cardHolder,
      ),
    );
  }
} 