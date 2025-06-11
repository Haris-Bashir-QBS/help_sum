import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class HeadingWithViewAll extends StatelessWidget {
  final String title;
  final VoidCallback onViewAllTap;

  const HeadingWithViewAll({
    super.key,
    required this.title,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        GestureDetector(
          onTap: onViewAllTap,
          child: CustomText(
            text: AppTexts.viewAll,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: AppPalette.primaryColor,
            decoration: TextDecoration.underline,
            decorationColor: AppPalette.primaryColor,
          ),
        ),
      ],
    );
  }
} 