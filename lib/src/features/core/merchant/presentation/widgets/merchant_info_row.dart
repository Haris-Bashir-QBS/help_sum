import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class InfoRow extends StatelessWidget {
  final String ratePerHour;
  final String averageRating;
  final String distanceKm;
  final String finishedJobs;

  const InfoRow({
    super.key,
    required this.ratePerHour,
    required this.averageRating,
    required this.distanceKm,
    required this.finishedJobs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoItem(AppAssets.dollar, ratePerHour, AppTexts.perHour),
        _buildInfoItem(
          AppAssets.starTwo,
          averageRating,
          AppTexts.averageRating,
        ),
        _buildInfoItem(
          AppAssets.distance,
          '${distanceKm} km',
          AppTexts.distance,
        ),
        _buildInfoItem(
          AppAssets.tick,
          finishedJobs.toString(),
          AppTexts.finishJobs,
        ),
      ],
    );
  }

  Widget _buildInfoItem(String iconPath, String value, String label) {
    return Column(
      children: [
        Image.asset(iconPath, width: 30.w, height: 30.h),
        CustomText(text: value, fontSize: 20.sp, fontWeight: FontWeight.w400),
        SizedBox(height: 4.h),
        CustomText(
          text: label,
          fontSize: 10.sp,
          color: AppPalette.darkGreyColor,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
