import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class CancelJobButton extends StatelessWidget {
  final VoidCallback onTap;

  const CancelJobButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppPalette.darkGreyColor),
          borderRadius: BorderRadius.circular(AppDimensions.appBorderRadius.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.close, color: AppPalette.errorColor),
            const Spacer(),
            CustomText(
              text: AppTexts.cancelJob,
              color: AppPalette.errorColor,
              fontSize: 16.sp,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
