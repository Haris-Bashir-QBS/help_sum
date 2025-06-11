import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class MerchantDetailsWidget extends StatelessWidget {
  final String name;
  final String profession;
  final bool isAvailable;

  const MerchantDetailsWidget({
    super.key,
    required this.name,
    required this.profession,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: name,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 5.h),
        CustomText(
          text: profession,
          fontSize: 16.sp,
          color: AppPalette.darkGreyColor,
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.circle,
              color: isAvailable ? Colors.green : Colors.red,
              size: 10.sp,
            ),
            SizedBox(width: 5.w),
            CustomText(
              text: isAvailable ? AppTexts.available : 'Unavailable',
              fontSize: 14.sp,
              color: isAvailable ? Colors.green : Colors.red,
            ),
          ],
        ),
      ],
    );
  }
} 