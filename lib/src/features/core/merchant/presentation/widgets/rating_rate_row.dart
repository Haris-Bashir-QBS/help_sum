import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class RatingRateRow extends StatelessWidget {
  final double rating;
  final int reviewsCount;

  const RatingRateRow({
    super.key,
    required this.rating,
    required this.reviewsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.star_rounded,
          color: AppPalette.starColor,
          size: 20.sp,
        ),
        SizedBox(width: 5.w),
        CustomText(
          text: rating.toStringAsFixed(1),
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(width: 10.w),
        CustomText(
          text: '($reviewsCount ${AppTexts.reviews})',
          fontSize: 16.sp,
          color: AppPalette.darkGreyColor,
        ),
      ],
    );
  }
} 