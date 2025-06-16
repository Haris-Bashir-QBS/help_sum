import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/rating_review_card.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class RatingReviewSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const RatingReviewSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: AppTexts.ratingsAndReviews,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 210.h,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: reviews.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return SizedBox(
                width: 200.w,
                child: RatingReviewCard(
                  reviewerName: review['reviewerName']!,
                  rating: review['rating'] as double,
                  reviewText: review['reviewText']!,
                  date: review['date']!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
