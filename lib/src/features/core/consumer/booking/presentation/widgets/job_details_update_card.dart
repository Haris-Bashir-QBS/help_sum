import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class JobDetailsUpdateCard extends StatelessWidget {
  final String? workLabel, workValue;
  const JobDetailsUpdateCard({super.key, this.workLabel, this.workValue});

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
            text: AppTexts.jobDetailsUpdates,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          Divider(),
          5.verticalSpace,
          _buildDetailRow(AppTexts.description, AppTexts.lowServiceCharges),
          10.verticalSpace,
          _buildDetailRow(
            workLabel ?? AppTexts.estimatedWorkTime,
            workValue ?? AppTexts.oneToTwoHours,
          ),
          10.verticalSpace,
          _buildDetailRow(AppTexts.amount, AppTexts.twoHundredDollars),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: label, fontWeight: FontWeight.bold),
        5.verticalSpace,
        CustomText(text: value),
      ],
    );
  }
}
