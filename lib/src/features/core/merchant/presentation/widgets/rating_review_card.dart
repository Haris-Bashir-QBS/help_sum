import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class RatingReviewCard extends StatelessWidget {
  final String reviewerName;
  final double rating;
  final String reviewText;
  final String date;

  const RatingReviewCard({
    super.key,
    required this.reviewerName,
    required this.rating,
    required this.reviewText,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: reviewerName,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 10.w),
              Icon(
                Icons.star_rounded,
                color: AppPalette.starColor,
                size: 18.sp,
              ),
              CustomText(
                text: rating.toStringAsFixed(1),
                fontSize: 14.sp,
                color: AppPalette.darkGreyColor,
              ),
              const Spacer(),
              CustomText(
                text: date,
                fontSize: 12.sp,
                color: AppPalette.darkGreyColor,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: reviewText,
            fontSize: 14.sp,
            color: AppPalette.darkGreyColor,
          ),
        ],
      ),
    );
  }
} 