import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class OfferDetailsCard extends StatelessWidget {
  const OfferDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingAllSides,
          ).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          CustomText(
            text: AppTexts.offerDetails,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          Divider(),
          5.verticalSpace,
          _buildDetailRow(AppTexts.estimatedWorkTime, AppTexts.oneToTwoHours),
          10.verticalSpace,
          _buildDetailRow(AppTexts.estimatedBudget, AppTexts.twoHundredDollars),
          10.verticalSpace,
          _buildDetailRow(AppTexts.jobDescription, AppTexts.pipeRepair),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title, fontWeight: FontWeight.bold),
        5.horizontalSpace,
        CustomText(text: value),
      ],
    );
  }
}
