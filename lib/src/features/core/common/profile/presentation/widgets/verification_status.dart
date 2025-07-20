import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class VerificationStatusIndicator extends StatelessWidget {
  final bool isVerified;
  final AlignmentGeometry alignment;

  const VerificationStatusIndicator({
    super.key,
    required this.isVerified,
    this.alignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color:
              isVerified ? AppPalette.secondaryColor : AppPalette.orangeColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isVerified ? Icons.check : Icons.person_remove_alt_1_rounded,
              size: 14.w,
            ),
            SizedBox(width: 4.w),
            CustomText(
              text: isVerified ? AppTexts.verified : AppTexts.unverified,
              fontSize: 12.sp,
              //   color: isVerified ? AppPalette.secondaryColor : AppPalette.orangeColor,
            ),
          ],
        ),
      ),
    );
  }
}
