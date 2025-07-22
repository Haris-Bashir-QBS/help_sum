import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/extensions/string_extensions.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/service_provider_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_status_header.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_timer.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_details_update_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/offer_details_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/service_location_map.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/service_time_card.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_provider.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_states.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/enums/payment_status.dart';

class JobDetailPage extends ConsumerStatefulWidget {
  final JobData job;
  final String? tabName;

  const JobDetailPage({super.key, required this.job, this.tabName});

  @override
  ConsumerState<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends ConsumerState<JobDetailPage> {
  bool showManageJobButton = true;

  @override
  void initState() {
    log(widget.job.status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("job status is ${widget.job.status}");
    _listener(context);

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
            text: widget.job.status.capitalizeAndReplaceUnderscore(),
            showContractTag:
                widget.job.status == JobStatus.in_progress.name ||
                widget.job.status == JobStatus.pending.name,
          ),
          10.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.job.status == JobStatus.in_progress.name &&
                      widget.job.jobStartTime != null) ...[
                    const BookingTimer(),
                    20.verticalSpace,
                  ],
                  Visibility(
                    visible:
                        widget.job.status == JobStatus.pending.name ||
                        widget.job.status ==
                            JobStatus.waitingConfirmation.name ||
                        widget.job.status == JobStatus.in_progress.name &&
                            widget.job.jobStartTime == null,
                    child: ServiceTimeCard(
                      //title: AppUtils.getServiceStartTimeTitle(job.status??""),
                      title: "Starting Time",
                      date: AppUtils.formatReadableDate(widget.job.date),
                      time: AppUtils.formatReadableTime(widget.job.time),
                    ),
                  ),

                  Visibility(
                    visible: widget.job.jobStartTime != null,
                    child: ServiceTimeCard(
                      //title: AppUtils.getServiceStartTimeTitle(job.status??""),
                      title: "Start Time",
                      date: widget.job.date,
                      time: '3:10 PM',
                    ),
                  ),
                  Visibility(
                    visible: widget.job.jobEndTime != null,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: ServiceTimeCard(
                            // title: AppUtils.getServiceEndTimeTitle(job.status),
                            title: "End Time",
                            date: widget.job.date,
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
                  OfferDetailsCard(job: widget.job),
                  20.verticalSpace,
                  //],
                  //_imagesWidget(),
                  // 20.verticalSpace,
                  Divider(),
                  LocationMapView(
                    latitude: widget.job.location.coordinates[1], // Latitude
                    longitude: widget.job.location.coordinates[0], // Longitude
                  ),
                  10.verticalSpace,
                  ServiceProviderCard(
                    title:
                        widget.job.consumerId.firstName +
                        widget.job.consumerId.lastName,
                    reviews: "N/A",
                    imageUrl: widget.job.consumerId.image,
                    showMapIcon: false,
                    onTap: () {},
                    onTapChat: () {
                      context.pushNamed(AppRoutes.chatScreen);
                    },
                    onTapMap: () {
                      context.pushNamed(AppRoutes.mapTracking);
                    },
                  ),
                  if (widget.job.status == JobStatus.ongoing.name ||
                      widget.job.status == JobStatus.approved.name ||
                      widget.job.status == JobStatus.waitingConfirmation.name
                  //|| job.status == JobStatus.pending//
                  ) ...[
                    JobDetailsUpdateCard(
                      heading: "Job Details Update",
                      showMerchantNotes: true,
                      workLabel:
                          AppUtils.parseJobStatus(widget.job.status) ==
                                      JobStatus.waitingPayment ||
                                  AppUtils.parseJobStatus(widget.job.status) ==
                                      JobStatus.completed
                              ? AppTexts.totalServiceTime
                              : null,
                      workValue:
                          AppUtils.parseJobStatus(widget.job.status) ==
                                      JobStatus.waitingPayment ||
                                  AppUtils.parseJobStatus(widget.job.status) ==
                                      JobStatus.completed
                              ? AppTexts.threeHours
                              : null,
                    ),
                    20.verticalSpace,
                  ],
                  // if (widget.job.status ==
                  //     JobStatus.waitingConfirmation.name) ...[
                  //   Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 14.w),
                  //     child: CustomButton(
                  //       text: "Chat with",
                  //       textColor: Colors.black,
                  //       color: Color(0xFF04DB00).withAlpha(40),
                  //       iconWidget: Image.asset(
                  //         AppAssets.chatIcon,
                  //         width: 25.w,
                  //         height: 25.h,
                  //         //color: Colors.white,
                  //       ),
                  //       onPressed: () {
                  //         context.pushNamed(AppRoutes.chatScreen);
                  //       },
                  //     ),
                  //   ),
                  //   10.verticalSpace,
                  // ],
                  // if (widget.job.status == JobStatus.rejected.name) ...[
                  //   _imageSlider(),
                  //   20.verticalSpace,
                  // ],
                  if (widget.job.status != JobStatus.waitingPayment.name) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Divider(),
                    ),
                  ],
                  if (widget.job.status == JobStatus.in_progress.name) ...[
                    _chatAndTrackConsumerButtons(context),
                  ],
                  if (widget.job.status == JobStatus.cancelled.name ||
                      widget.job.status == JobStatus.rejected.name)
                    _serviceProviderCard(),
                  if (widget.job.status == JobStatus.pending.name) ...[
                    10.verticalSpace,
                    _approveAndRejectJobButtons(context),
                  ],
                  // if (jobStatus == JobStatus.approved) ...[
                  //   10.verticalSpace,
                  //   _otherOptionsButton(context),
                  // ],
                  if (widget.job.status == JobStatus.in_progress.name ||
                      widget.job.status == JobStatus.accepted.name) ...[
                    20.verticalSpace,
                    _bookingConfirmAndCancelButtons(context),
                  ],
                  if (widget.job.paymentStatus == PaymentStatus.paid.name &&
                      widget.job.status != AppTexts.completed) ...[
                    10.verticalSpace,
                    _paymentReceivedButton(),
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

  ServiceProviderCard _serviceProviderCard() {
    return ServiceProviderCard(
      title: widget.job.consumerId.firstName,
      reviews: AppTexts.ratingAndReviews,
      showMapIcon: false,
      showChatIcon: false,
      onTap: () {},
      onTapChat: () {},
      onTapMap: () {},
    );
  }

  // JobImageSlider _imageSlider() {
  //   return JobImageSlider(
  //                   imageUrls: [
  //                     'https://picsum.photos/id/237/200/300',
  //                     'https://picsum.photos/id/238/200/300',
  //                     'https://picsum.photos/id/239/200/300',
  //                     'https://picsum.photos/id/240/200/300',
  //                   ],
  //                 );
  // }

  void _listener(BuildContext context) {
    ref.listen<MerchantJobsState>(merchantJobsNotifierProvider, (
      previous,
      current,
    ) {
      // Handle loading state
      if (current is JobActionLoading) {
        // Show loading indicator if needed
      }
      // Handle success states
      else if (current is JobActionSuccess) {
        if (current.action == 'start') {
          // Job started successfully
          Navigator.pop(context);
        } else if (current.action == 'complete') {
          // Job completed successfully
          showJobReceiptDialog(context);
        } else if (current.action == 'cancel') {
          // Job cancelled successfully
          Navigator.pop(context);
        }
      }
      // Handle error states
      else if (current is JobActionError) {
        CustomToast.errorToast(context: context, message: current.message);
      }
    });
  }

  Widget _paymentReceivedButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: CustomButton(
        text: "Payment Received",
        color: AppPalette.primaryColor,
        onPressed: () {},
      ),
    );
  }

  Widget _chatAndTrackConsumerButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: CustomButton.bordered(
            text: "Track ${widget.job.consumerId.firstName}",
            iconWidget: Image.asset(
              AppAssets.trgetIcon,
              width: 20.w,
              height: 20.h,
            ),
            onPressed: () {
              context.pushNamed(AppRoutes.mapTracking);
            },
          ),
        ),
        10.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: CustomButton.bordered(
            text: "Chat with ${widget.job.consumerId.firstName}",
            iconWidget: Image.asset(
              AppAssets.chatIcon,
              width: 20.w,
              height: 20.h,
            ),
            onPressed: () {
              context.pushNamed(AppRoutes.chatScreen);
            },
          ),
        ),
      ],
    );
  }

  Padding _approveAndRejectJobButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingAllSides),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "Approve Job",
              color: AppPalette.primaryColor.withAlpha(220),
              textColor: Colors.white,
              onPressed: () {
                ref
                    .read(merchantJobsNotifierProvider.notifier)
                    .changeJobStatus(
                      jobId: widget.job.id,
                      action: "accept",
                      //  context: context,
                    );
                // Fluttertoast.showToast(msg: "Job Approved");
                // context.pop();
                // _showJobStartConfirmationDialog(context);
              },
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: CustomButton(
              text: "Reject Job",
              textColor: Colors.white,
              color: AppPalette.redColor,
              onPressed: () {
                Fluttertoast.showToast(msg: "Job Rejected");
                ref
                    .read(merchantJobsNotifierProvider.notifier)
                    .changeJobStatus(
                      jobId: widget.job.id,
                      action: "reject",
                      // ctx: context,
                    );
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Update the button callbacks
  Widget _bookingConfirmAndCancelButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingAllSides),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text:
                  widget.job.status == JobStatus.accepted.name
                      ? AppTexts.startJob
                      : AppTexts.endJob,
              color: AppPalette.primaryColor.withAlpha(220),
              textColor: Colors.white,
              onPressed: () {
                if (widget.job.status == JobStatus.accepted.name) {
                  // Call start job API without awaiting
                  ref
                      .read(merchantJobsNotifierProvider.notifier)
                      .startJob(jobId: widget.job.id);
                } else {
                  // Show confirmation dialog for ending job
                  _showJobEndConfirmationDialog(context);
                }
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
                ref
                    .read(merchantJobsNotifierProvider.notifier)
                    .changeJobStatus(jobId: widget.job.id, action: "cancel");
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showJobEndConfirmationDialog(BuildContext context) async {
    await AnimatedStatusDialog.show(
      context: context,
      isSuccess: true,
      title: "Are you sure to end this job?",
      primaryButtonText: AppTexts.no,
      onSecondaryTap: () {
        // Call complete job API without awaiting
        ref
            .read(merchantJobsNotifierProvider.notifier)
            .completeJob(jobId: widget.job.id);
        // The listener will handle showing the receipt dialog
      },
      secondaryButtonText: AppTexts.yes,
    );
  }

  void showJobReceiptDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismiss on outside tap
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Job Receipt',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 12),

                const Text(
                  'Service Started on:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Mon, 5th Feb 2023'),
                const Text('06:31 PM'),
                const SizedBox(height: 16),

                const Text(
                  'Service Ended on:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Mon, 5th Feb 2023'),
                const Text('06:31 PM'),
                const SizedBox(height: 16),

                const Text(
                  'Total Time:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('00:10:12'),
                const SizedBox(height: 16),

                const Text(
                  'Total Amount:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('\$500'),
                const SizedBox(height: 24),

                Center(
                  child: SizedBox(
                    width: 150.w,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // First pop (dialog)
                        Navigator.pop(context); // Second pop (parent page)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Done"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _otherOptionsButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          if (showManageJobButton == true) ...[
            CustomButton(
              text: "Manage Job",
              color: AppPalette.primaryColor,
              onPressed: () async {
                bool? isSuccess = await context.pushNamed(AppRoutes.manageJob);
                if (isSuccess == true) {
                  showManageJobButton = false;
                  Fluttertoast.showToast(msg: "Job Updated Successfully");
                  setState(() {});
                }
              },
            ),
            10.verticalSpace,
          ],

          CustomButton(
            text: "Start Job",
            color: AppPalette.primaryColor,
            onPressed: () {
              // context.pop();

              ref
                  .read(merchantJobsNotifierProvider.notifier)
                  .changeJobStatus(
                    jobId: widget.job.id,
                    action: "start",
                    //  ctx: context,
                  );
              Fluttertoast.showToast(msg: "Job Started");
            },
          ),
        ],
      ),
    );
  }
}
