import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_rating_widget.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
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
      appBar: const CustomAppBar(title: AppTexts.rateMerchant),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 94.h),
                _buildRatingWidget(),
                SizedBox(height: 73.h),
                _buildReviewField(),
                SizedBox(height: 32.h),
                _buildSubmitButton(),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingWidget() {
    return CustomRatingWidget(
      initialRating: _rating,
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
      },
    );
  }

  Widget _buildReviewField() {
    return CustomTextFormField(
      controller: _reviewController,
      hint: AppTexts.pleaseGiveReview,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      borderColor: AppPalette.blackColor,
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: AppTexts.done,
      onPressed: _submitReview,
      color: AppPalette.primaryColor,
      textColor: Colors.white,
    );
  }
}
