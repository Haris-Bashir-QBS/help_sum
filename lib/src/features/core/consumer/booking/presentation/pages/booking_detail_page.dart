import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/enums/payment_status.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/core/extensions/string_extensions.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/service_provider_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_status_header.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_timer.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/offer_details_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/service_location_map.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/service_time_card.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/router/app_routes.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../widgets/job_image_slider.dart';

class BookingDetailPage extends StatelessWidget {
  final JobData job;
  final String? tabName;

  const BookingDetailPage({super.key, required this.job, this.tabName});

  @override
  Widget build(BuildContext context) {
    print("job status is ${job.status}");
    return Scaffold(
      appBar: CustomAppBar(
        title: AppTexts.bookingDetail,
        onBackButtonPressed: () {
          context.pop(true);
        },
      ),
      body: Column(
        children: [
          20.verticalSpace,
          BookingStatusHeader(
            text: job.status.capitalizeAndReplaceUnderscore(),
            showContractTag: job.status == JobStatus.in_progress.name,
            // showContractTag: false,
          ),
          10.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (job.status == JobStatus.in_progress.name &&
                      job.jobStartTime != null) ...[
                    const BookingTimer(),
                    20.verticalSpace,
                  ],
                  Visibility(
                    visible:
                        job.status == JobStatus.pending.name ||
                        job.status == JobStatus.waitingConfirmation.name ||
                        job.status == JobStatus.in_progress.name &&
                            job.jobStartTime == null,
                    child: ServiceTimeCard(
                      //title: AppUtils.getServiceStartTimeTitle(job.status??""),
                      title: "Starting Time",
                      date: AppUtils.formatReadableDate(job.date),
                      time: AppUtils.formatReadableTime(job.time),
                    ),
                  ),

                  Visibility(
                    visible: job.jobStartTime != null,
                    child: ServiceTimeCard(
                      //title: AppUtils.getServiceStartTimeTitle(job.status??""),
                      title: "Start Time",
                      date: job.date,
                      time: '3:10 PM',
                    ),
                  ),
                  Visibility(
                    visible: job.jobEndTime != null,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: ServiceTimeCard(
                            // title: AppUtils.getServiceEndTimeTitle(job.status),
                            title: "End Time",
                            date: job.date,
                            time: '2:10 PM',
                          ),
                        ),
                        10.verticalSpace,
                        Divider(),
                      ],
                    ),
                  ),

                  10.verticalSpace,
                  // if (job.status != JobStatus.waitingPayment.name &&
                  // //    job.status != JobStatus.cancelled.name
                  // //    && job.status != JobStatus.rejected.name
                  // ) ...[
                  OfferDetailsCard(job: job),
                  20.verticalSpace,
                  //],
                  //_imagesWidget(),
                  // 20.verticalSpace,
                  Divider(),
                  LocationMapView(
                    latitude: job.location.coordinates[1], // Latitude
                    longitude: job.location.coordinates[0], // Longitude
                  ),
                  10.verticalSpace,
                  ServiceProviderCard(
                    title: job.merchantId.firstName + job.merchantId.lastName,
                    reviews: job.merchantId.averageRating.toString(),
                    imageUrl: job.merchantId.image,
                    showMapIcon: false,
                    onTap: () {},
                    onTapChat: () {
                      context.pushNamed(AppRoutes.chatScreen);
                    },
                    onTapMap: () {
                      context.pushNamed(AppRoutes.mapTracking);
                    },
                  ),
                  if ((job.paymentStatus == PaymentStatus.escrowed.name ||
                          job.paymentStatus == PaymentStatus.paid.name) &&
                      (job.status == JobStatus.waitingPayment.name ||
                          job.status == JobStatus.completed.name ||
                          job.status == JobStatus.in_progress.name ||
                          job.status == JobStatus.accepted.name)) ...[
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingAllSides,
                      ),
                      child: CustomButton(
                        text:
                            job.paymentStatus == PaymentStatus.escrowed.name
                                ? "Pay now"
                                : "Paid",
                        onPressed: () {
                          if (job.paymentStatus ==
                              PaymentStatus.escrowed.name) {
                            context.pushNamed(
                              AppRoutes.paymentMethod,
                              extra: job,
                            );
                          }
                        },
                        color:
                            job.paymentStatus == PaymentStatus.escrowed.name
                                ? context.primaryColor
                                : null,
                      ),
                    ),
                  ],
                  if (job.status == JobStatus.pending.name) ...[
                    10.verticalSpace,
                    _otherOptionsButton(context),
                  ],
                  if (job.status == JobStatus.waitingConfirmation.name) ...[
                    20.verticalSpace,
                    _bookingConfirmAndCancelButtons(context),
                  ],
                  if (job.status == JobStatus.completed.name &&
                      job.isConsumerRated != true) ...[
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.h),
                      child: CustomButton(
                        text: AppTexts.rate,
                        color: context.primaryColor,
                        onPressed: () {
                          context.pushNamed(AppRoutes.rateScreen, extra: job);
                        },
                      ),
                    ),
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

  JobImageSlider _imagesWidget() {
    return JobImageSlider(
      imageUrls: [
        'https://picsum.photos/id/237/200/300',
        'https://picsum.photos/id/238/200/300',
        'https://picsum.photos/id/239/200/300',
        'https://picsum.photos/id/240/200/300',
      ],
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
