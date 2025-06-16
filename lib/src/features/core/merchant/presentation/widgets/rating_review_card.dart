import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppPalette.extraLightGreyColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer row
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: const NetworkImage(
                  'https://picsum.photos/200',
                ), // Placeholder image
              ),
              SizedBox(width: 10.w),
              CustomText(
                text: reviewerName,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Review text
          CustomText(text: reviewText, fontSize: 14.sp, maxLines: 5),

          SizedBox(height: 10.h),

          // Rating bar
          RatingBarIndicator(
            rating: rating,
            itemBuilder:
                (context, index) => const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 20.sp,
            unratedColor: Colors.grey[300],
            direction: Axis.horizontal,
          ),
        ],
      ),
    );
  }
}
