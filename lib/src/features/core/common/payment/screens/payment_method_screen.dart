import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  void _handlePaymentMethodSelected(BuildContext context, String method) {
    switch (method) {
      case AppTexts.creditDebitCard:
        context.pushNamed(AppRoutes.cardDetails);
        break;
      case AppTexts.paypal:
        // TODO: Implement PayPal payment
        break;
      case AppTexts.applePay:
        // TODO: Implement Apple Pay
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppTexts.selectPaymentMethod,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: AppTexts.choosePaymentMethod,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 24.h),
            _buildPaymentMethodCard(
              context,
              AppTexts.creditDebitCard,
              Icons.credit_card,
            ),
            SizedBox(height: 16.h),
            _buildPaymentMethodCard(
              context,
              AppTexts.paypal,
              Icons.payment,
            ),
            SizedBox(height: 16.h),
            _buildPaymentMethodCard(
              context,
              AppTexts.applePay,
              Icons.apple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 24.w),
        title: CustomText(
          text: title,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _handlePaymentMethodSelected(context, title),
      ),
    );
  }
} 