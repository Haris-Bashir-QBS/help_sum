import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/rate_job_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/notifiers/rating_state.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/providers/rating_provider.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_rating_widget.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';

class RateJobScreen extends ConsumerStatefulWidget {
  const RateJobScreen({super.key, this.isEdit = false, required this.job});
  final bool isEdit;
  final JobData job;

  @override
  ConsumerState<RateJobScreen> createState() => _RateJobScreenState();
}

class _RateJobScreenState extends ConsumerState<RateJobScreen> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_rating == 0.0) {
      CustomToast.errorToast(
        context: context,
        message: "Please provide a rating",
      );
      return;
    }

    final params = RateJobRequestModel(
      jobId: widget.job.id,
      rating: _rating.toInt(),
      review: _reviewController.text,
    );

    ref.read(ratingNotifierProvider.notifier).rateJob(params);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(ratingNotifierProvider, (previous, current) {
      if (current is RatingSuccess) {
        CustomToast.successToast(
          context: context,
          message: 'Rating submitted successfully',
        );
        context.pop();
        context.pop();
      } else if (current is RatingError) {
        CustomToast.successToast(
          context: context,
          message: current.message,
        );
     
      }
    });
    final ratingState = ref.watch(ratingNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.rateMerchant),
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
                _buildSubmitButton(ratingState),
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

  Widget _buildSubmitButton(RatingState state) {
    return CustomButton(
      text: AppTexts.done,
      onPressed: _submitReview,
      color: AppPalette.primaryColor,
      textColor: Colors.white,
      isLoading: state is RatingLoading,
    );
  }
}
