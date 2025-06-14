import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/circular_icon_container.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class PaymentAmountCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback? onTap;

  const PaymentAmountCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(vertical: 18.h).copyWith(left: 24.w),
        decoration: BoxDecoration(
          color: AppPalette.fillColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircularIconContainer(imagePath: iconPath, size: 25, padding: 10),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: title, fontWeight: FontWeight.w500),
                5.verticalSpace,
                CustomText(
                  text: subtitle,
                  fontSize: 13.sp,
                  color: AppPalette.blackColor.withAlpha(120),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
