import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/themes/app_dimensions.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/common/main_navigation/domain/model/job_model.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/service_provider_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_status_header.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_timer.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_details_update_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/offer_details_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/service_location_map.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/service_time_card.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_image_slider.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class BookingDetailPage extends StatelessWidget {
  final JobModel job;
  final String? tabName;

  const BookingDetailPage({super.key, required this.job, this.tabName});

  @override
  Widget build(BuildContext context) {
    print("job status is ${job.status}");
    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.bookingDetail),
      body: Column(
        children: [
          20.verticalSpace,
          BookingStatusHeader(
            text: tabName ?? "",
            showContractTag: job.status == JobStatus.inProgress,
          ),
          10.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (job.status == JobStatus.inProgress) ...[
                    const BookingTimer(),
                    20.verticalSpace,
                  ],

                  ServiceTimeCard(
                    title: AppUtils.getServiceStartTimeTitle(job.status),
                    date: 'Tuesday, 11 November',
                    time: '3:10 PM',
                  ),
                  20.verticalSpace,
                  ServiceTimeCard(
                    title: AppUtils.getServiceEndTimeTitle(job.status),
                    date: 'Thursday, 12 November',
                    time: '2:10 PM',
                  ),
                  20.verticalSpace,
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomText(
                      text: AppTexts.otherOptions,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  20.verticalSpace,
                  if (job.status == JobStatus.ongoing ||
                      job.status == JobStatus.approved ||
                      job.status == JobStatus.pending) ...[
                    JobDetailsUpdateCard(
                      workLabel:
                          job.status == JobStatus.waitingPayment ||
                                  job.status == JobStatus.completed
                              ? AppTexts.totalServiceTime
                              : null,
                      workValue:
                          job.status == JobStatus.waitingPayment ||
                                  job.status == JobStatus.completed
                              ? AppTexts.threeHours
                              : null,
                    ),
                    20.verticalSpace,
                  ],

                  if (job.status != JobStatus.waitingPayment &&
                      job.status != JobStatus.cancelled &&
                      job.status != JobStatus.rejected) ...[
                    const OfferDetailsCard(),
                    20.verticalSpace,
                  ],
                  JobImageSlider(
                    imageUrls: [
                      'https://picsum.photos/id/237/200/300',
                      'https://picsum.photos/id/238/200/300',
                      'https://picsum.photos/id/239/200/300',
                      'https://picsum.photos/id/240/200/300',
                    ],
                  ),
                  20.verticalSpace,

                  if (job.status != JobStatus.inProgress) ...[
                    ServiceLocationMap(latitude: 144, longitude: 146),
                    10.verticalSpace,
                  ],
                  ServiceProviderCard(
                    title: job.customerName,
                    reviews: AppTexts.ratingAndReviews,
                    showMapIcon:
                        job.status != JobStatus.cancelled &&
                        job.status != JobStatus.waitingPayment &&
                        job.status != JobStatus.completed &&
                        job.status != JobStatus.rejected &&
                        job.status != JobStatus.waitingConfirmation,
                    onTap: () {
                      // TODO: Navigate to service provider profile
                    },
                    onTapChat: () {
                      context.pushNamed(AppRoutes.chatScreen);
                    },
                    onTapMap: () {
                      context.pushNamed(AppRoutes.mapTracking);
                    },
                  ),

                  if (job.status == JobStatus.pending) ...[
                    10.verticalSpace,
                    _otherOptionsButton(context),
                  ],
                  if (job.status == JobStatus.waitingConfirmation) ...[
                    20.verticalSpace,
                    _bookingConfirmAndCancelButtons(context),
                  ],
                  50.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _bookingConfirmAndCancelButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingAllSides),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: AppTexts.confirmJob,
              color: AppPalette.primaryColor.withAlpha(220),
              textColor: Colors.white,
              onPressed: () {
                _showJobStartConfirmationDialog(context);
              },
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: CustomButton(
              text: AppTexts.cancelJob,
              textColor: Colors.white,
              color: AppPalette.redColor,
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showJobStartConfirmationDialog(BuildContext context) async {
    await AnimatedStatusDialog.show(
      context: context,
      isSuccess: true,
      title: AppTexts.areYouSureToStartThisJob,
      primaryButtonText: AppTexts.yes,
      onPrimaryTap: () {
        context.pop();
      },
      secondaryButtonText: AppTexts.no,
    );
  }

  Padding _otherOptionsButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomButton.bordered(
        text: AppTexts.otherOptions,
        onPressed: () {
          context.pushNamed(AppRoutes.otherOptions);
        },
      ),
    );
  }
}
