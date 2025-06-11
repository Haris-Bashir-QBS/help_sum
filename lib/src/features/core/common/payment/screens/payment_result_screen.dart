import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class PaymentResultScreen extends StatelessWidget {
  final bool isSuccess;

  const PaymentResultScreen({
    super.key,
    required this.isSuccess,
  });

  void _handleButtonPress(BuildContext context) {
    if (isSuccess) {
      context.goNamed(AppRoutes.mainNavigation);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppTexts.paymentResult,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              size: 100.w,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            SizedBox(height: 24.h),
            CustomText(
              text: isSuccess ? AppTexts.paymentSuccess : AppTexts.paymentFailed,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: isSuccess ? AppTexts.backToHome : AppTexts.tryAgain,
              onPressed: () => _handleButtonPress(context),
            ),
          ],
        ),
      ),
    );
  }
} 