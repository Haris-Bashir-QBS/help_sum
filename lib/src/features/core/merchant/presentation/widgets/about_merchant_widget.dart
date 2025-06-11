import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class AboutMerchantWidget extends StatelessWidget {
  final String aboutText;

  const AboutMerchantWidget({
    super.key,
    required this.aboutText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppTexts.aboutMerchant,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 10.h),
        CustomText(
          text: aboutText,
          fontSize: 14.sp,
          color: AppPalette.darkGreyColor,
        ),
      ],
    );
  }
} 