import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_rating_widget.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';

class RateMerchantScreen extends StatefulWidget {
  const RateMerchantScreen({super.key});

  @override
  State<RateMerchantScreen> createState() => _RateMerchantScreenState();
}

class _RateMerchantScreenState extends State<RateMerchantScreen> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    // TODO: Implement logic to submit the rating and review
    print('Rating: $_rating');
    print('Review: ${_reviewController.text}');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppTexts.rateMerchant,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            CustomRatingWidget(
              initialRating: _rating,
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 32.h),
            CustomTextFormField(
              controller: _reviewController,
              hint: AppTexts.pleaseGiveReview,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
            const Spacer(),
            CustomButton(
              text: AppTexts.done,
              onPressed: _submitReview,
            ),
          ],
        ),
      ),
    );
  }
} 