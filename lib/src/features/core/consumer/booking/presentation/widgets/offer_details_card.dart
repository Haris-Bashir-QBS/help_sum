import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class OfferDetailsCard extends StatelessWidget {
  final JobData job;
  const OfferDetailsCard({super.key, required this.job});

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
          3.verticalSpace,
          _buildDetailRow(AppTexts.jobTitle, job.title),
          10.verticalSpace,
          _buildDetailRow(AppTexts.jobDescription, job.description),
          10.verticalSpace,
          _buildDetailRow(AppTexts.estimatedWorkTime, job.estimatedWorkTime),
          10.verticalSpace,
          _buildDetailRow(AppTexts.estimatedBudget, job.offer.toString()),
          10.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title, fontWeight: FontWeight.bold),
        13.horizontalSpace,
        CustomText(text: value),
      ],
    );
  }
}
