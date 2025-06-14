import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/common/payment/widgets/payment_result_action_button.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class PaymentResultScreen extends StatelessWidget {
  final bool isSuccess;

  const PaymentResultScreen({super.key, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.paymentResult, centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              90.verticalSpace,
              _buildSuccessIcon(),
              SizedBox(height: 24.h),
              _buildStatusText(),
              SizedBox(height: 32.h),
              _buildMessageText(),
              SizedBox(height: 32.h),
              _buildActionButtons(context),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Image.asset(AppAssets.successIcon, width: 154.w, height: 156.h);
  }

  Widget _buildStatusText() {
    return CustomText(
      text: isSuccess ? AppTexts.successfullyCompleted : AppTexts.paymentFailed,
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildMessageText() {
    return CustomText(
      text: isSuccess ? AppTexts.thankYouMessage : AppTexts.paymentFailed,
      fontSize: 19.sp,
      maxLines: 5,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        PaymentResultActionButton(
          iconPath: AppAssets.refreshIcon,
          text: AppTexts.bookAgain,
          onTap: () {},
        ),
        SizedBox(width: 16.w),
        PaymentResultActionButton(
          iconPath: AppAssets.starIcon,
          text: AppTexts.rate,
          onTap: () {
            context.pushNamed(AppRoutes.rateScreen);
          },
        ),
      ],
    );
  }
}
