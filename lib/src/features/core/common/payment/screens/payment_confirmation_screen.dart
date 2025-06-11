import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/common/payment/models/card_detail_params.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final CardDetailParams params;

  const PaymentConfirmationScreen({
    super.key,
    required this.params,
  });

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontSize: 16.sp,
          ),
          CustomText(
            text: value,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      context.pushNamed(
        AppRoutes.paymentResult,
        extra: {'isSuccess': true},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppTexts.paymentConfirmation),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: AppTexts.paymentDetails,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 24.h),
            _buildInfoRow(
              AppTexts.amount,
              '\$${params.amount.toStringAsFixed(2)}',
            ),
            _buildInfoRow(
              AppTexts.cardNumber,
              AppUtils.maskCardNumber(params.cardNumber),
            ),
            _buildInfoRow(
              AppTexts.cardHolderName,
              params.cardHolderName,
            ),
            const Spacer(),
            CustomButton(
              text: AppTexts.confirmPayment,
              onPressed: () => _processPayment(context),
            ),
          ],
        ),
      ),
    );
  }
} 