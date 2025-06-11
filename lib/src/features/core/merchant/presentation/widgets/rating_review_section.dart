import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/rating_review_card.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class RatingReviewSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const RatingReviewSection({
    super.key,
    required this.reviews,
  });

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
        SizedBox(height: 10.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return RatingReviewCard(
              reviewerName: review['reviewerName']!,
              rating: review['rating'] as double,
              reviewText: review['reviewText']!,
              date: review['date']!,
            );
          },
        ),
      ],
    );
  }
} 